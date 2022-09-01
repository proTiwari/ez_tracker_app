import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:ez_tracker_app/models/tracker_record/tracker_record_model.dart';
import 'package:ez_tracker_app/services/firestore_service.dart';
import 'package:ez_tracker_app/services/pref_service.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
import 'auth_service.dart';

// Todo: Changed to 15 minutes
const int _timeoutMinutes = 5;

class BackgroundLocationService {
  BackgroundLocationService._();
  static final instance = BackgroundLocationService._();

  final firebaseAuthService = AuthService.instance;
  final firestoreDBService = FireStoreService.instance;
  final preferenceService = PreferenceService.instance;

  Timer? _timer;
  int trackingEndTime = 0;

  double vehicleSpeed = 0;
  bool wasSpeedAboveLimit = false;
  bool get isInMotion => vehicleSpeed >= 20.0;
  bool get isTimerStopped => trackingEndTime == 0;

  //===========================
  // start and end timer code
  //==========================

  void startTimer() {
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

  Future<void> initLocationTrackingEvent() async {
    // final isTrackingStarted = await PreferenceService.instance
    //     .getBoolPrefValue(key: PrefKeys.isTrackingStarted);
    // if (isTrackingStarted) return;
    UtilityHelper.showLog('initLocationTrackingEvent: Called');
    BackgroundLocation.setAndroidNotification(
      title: "Track-Ez",
      message: "Your activites are logged",
      icon: "@mipmap/ic_launcher",
    );
    BackgroundLocation.setAndroidConfiguration(1000);
    BackgroundLocation.startLocationService(forceAndroidLocationManager: true);
    BackgroundLocation.getLocationUpdates((location) {
      // preferenceService.setBoolPrefValue(
      //     value: true, key: PrefKeys.isTrackingStarted);
      vehicleSpeed = location.speed == null
          ? 0
          : (((location.speed ?? 0) * 18) /
              5); //Converting position speed from m/s to km/hr
      checkSpeedAndStartTracking();
    });
  }

  void checkSpeedAndStartTracking() {
    UtilityHelper.showLog('VehicleSpeed ${vehicleSpeed.toString()}');
    if (isInMotion) {
      stopTimer();
      wasSpeedAboveLimit = true;
      UtilityHelper.showLog("In motion");
      // Check Record And Start Tracking
      checkRecordItLocallyAndPrepareOrUpload();
    } else if (isTimerStopped && wasSpeedAboveLimit) {
      // Check Current time
      // time not started then start it else keep it as it's
      wasSpeedAboveLimit = false;
      startTimer();
      UtilityHelper.showLog("Not in motion");
    }
  }

  //===========================
  // Check Local Record and prepare
  //==========================
  void checkRecordItLocallyAndPrepareOrUpload() async {
    final localRecordId =
        await preferenceService.getStringPrefValue(key: PrefKeys.recordId);
    // get current position & prepare latlong model
    final Location position = await BackgroundLocation().getCurrentLocation();
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
}
