import 'dart:async';
import 'package:ez_tracker_app/models/tracker_record/tracker_record_model.dart';
import 'package:ez_tracker_app/services/firestore_service.dart';
import 'package:ez_tracker_app/services/pref_service.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import 'auth_service.dart';

// Todo: Changed to 15 minutes
const int _timeoutMinutes = 5;

class SensorPlusService {
  SensorPlusService._();
  static final instance = SensorPlusService._();

  final firebaseAuthService = AuthService.instance;
  final firestoreDBService = FireStoreService.instance;
  final preferenceService = PreferenceService.instance;

  StreamSubscription<Position>? positionStream;

  bool? enabledLocationService;
  bool? get isLocationServiceEnabled => enabledLocationService;

  // double _velocity = 0;
  // double get velocity => _velocity;

  Timer? _timer;
  int trackingEndTime = 0;

  double vehicleSpeed = 0;
  bool isSpeedWasAboveLimit = false;
  bool get isInMotion => vehicleSpeed >= 10.0;
  bool get isTimerStopped => trackingEndTime == 0;

  //===========================
  // start and end timer code
  //==========================

  void startTimer() {
    print("timer: ${_timer?.tick}");
    if (trackingEndTime != 0) return;
    trackingEndTime = 60 * _timeoutMinutes; // 15 minute
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        UtilityHelper.showLog('Timer**, $trackingEndTime');
        if (trackingEndTime == 0) {
          stopTimer();
          checkRecordItLocallyAndPrepareOrUpload();
        } else {
          trackingEndTime--;
        }
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    trackingEndTime = 0;
  }

  //===========================
  // Location Tracking for speed.
  //==========================

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 1,
  );

  void initLocationTrackingEvent() {
    print("initLocationTrackingEvent");
    UtilityHelper.showLog('initLocationTrackingEvent: Called');
    deinitLocationTrackingEvent();
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      preferenceService.setBoolPrefValue(
          value: true, key: PrefKeys.isTrackingStarted);
      vehicleSpeed = position == null
          ? 0
          : ((position.speed * 18) /
              5); //Converting position speed from m/s to km/hr
      checkSpeedAndStartTracking();
      print("vehicle speed: ${vehicleSpeed}");
    });
    // int tempTimer = 0;
    // Timer.periodic(
    //   const Duration(seconds: 1),
    //   (Timer timer) {
    //     tempTimer++;
    //     if (tempTimer >= 10 && tempTimer < 20) {
    //       vehicleSpeed = 21;
    //     } else if (tempTimer >= 20 && tempTimer < 30) {
    //       vehicleSpeed--;
    //     } else if (tempTimer >= 30 && tempTimer < 40) {
    //       vehicleSpeed++;
    //     } else {
    //       vehicleSpeed = 0;
    //     }
    //     checkSpeedAndStartTracking();
    //   },
    // );
  }

  void deinitLocationTrackingEvent() {
    positionStream?.cancel();
    positionStream = null;
  }

  void checkSpeedAndStartTracking() {
    UtilityHelper.showLog(vehicleSpeed.toString());
    // checkRecordItLocallyAndPrepareOrUpload();
    if (isInMotion) {
      stopTimer();
      isSpeedWasAboveLimit = true;
      UtilityHelper.showLog("In motion");
      // Check Record And Start Tracking
      checkRecordItLocallyAndPrepareOrUpload();
    } else if (isTimerStopped && isSpeedWasAboveLimit) {
      // Check Current time
      // time not started then start it else keep it as it's
      isSpeedWasAboveLimit = false;
      startTimer();
      UtilityHelper.showLog("Not in motion");
    }
  }

  //===========================
  // Check Local Record and prepare
  //==========================
  void checkRecordItLocallyAndPrepareOrUpload() async {
    await checkLocationServiceEnabled();
    if (isLocationServiceEnabled ?? false) {
      final localRecordId =
          await preferenceService.getStringPrefValue(key: PrefKeys.recordId);
      // get current position & prepare latlong model
      final Position position = await Geolocator.getCurrentPosition();
      final LatLongModel latLongModel = LatLongModel(
        lat: position.latitude,
        long: position.longitude,
        createdDate: DateTime.now(),
      );

      // if record exist
      UtilityHelper.showLog("=============================");
      UtilityHelper.showLog("Record Exist ${localRecordId.isNotEmpty}");
      UtilityHelper.showLog("IS In Motion $isInMotion");
      UtilityHelper.showLog("=============================");
      print("latLongModel:${latLongModel.lat} ${latLongModel.long}");
      if (localRecordId.isNotEmpty && isTimerStopped && !(isInMotion)) {

        UtilityHelper.showLog("Record Exist So Uploaded to Firestore");
        final recordData =
            await preferenceService.getMapPrefValue(key: PrefKeys.driveRecord);
        TrackerRecordModel recordModel =
            TrackerRecordModel.fromMap(recordData, localRecordId);
        // update stored model
        recordModel = recordModel.copyWith(
          recordId: localRecordId,
          recordCreatedDate: DateTime.now(),
          destinationDetails: latLongModel,
          statusID: RecordStatusType.unclassified.id,
        );
        await prepareRecordAndUploadToFirestore(recordModel);
      } else if (localRecordId.isEmpty) {
        print("Record Doesn't Exist So Created New");
        // if record doesn't exist
        // prepar record locally with source address.
        UtilityHelper.showLog("Record Doesn't Exist So Created New");
        final recordId = const Uuid().v4();
        TrackerRecordModel recordModel = TrackerRecordModel(
          recordId: recordId,
          sourceDetails: latLongModel,
        );
        final recordData = recordModel.toMap(recordId: recordId);
        await preferenceService.setMapPrefValue(
            value: recordData, key: PrefKeys.driveRecord);
        await preferenceService.setStringPrefValue(
            value: recordId, key: PrefKeys.recordId);
      }
    }
  }

  //===========================
  // Firestore upload code
  //==========================
  Future<void> prepareRecordAndUploadToFirestore(
      TrackerRecordModel recordModel) async {
    await Firebase.initializeApp();
    recordModel = recordModel.copyWith(
      userId: firebaseAuthService.currentUser()?.uid,
    );
    await firestoreDBService.setData(
      path: '${FireStoreEndPoints.driveRecords}/${recordModel.recordId}',
      data: recordModel.toMap(
        recordId: recordModel.recordId ?? '',
      ),
      withMerge: false,
    );
    await preferenceService
        .setMapPrefValue(value: {}, key: PrefKeys.driveRecord);
    await preferenceService.setStringPrefValue(
        value: '', key: PrefKeys.recordId);
    UtilityHelper.showLog("Record Deleted From Location Storage");
  }

  //===========================
  // Location check code
  //==========================
  Future<void> checkLocationServiceEnabled() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      enabledLocationService = false;
    } else if (permission == LocationPermission.deniedForever) {
      enabledLocationService = false;
    } else {
      enabledLocationService = true;
    }
    UtilityHelper.showLog('IsLocationEnabled: $isLocationServiceEnabled');
  }
}