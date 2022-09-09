import 'package:ez_tracker_app/models/tracker_record/tracker_record_model.dart';
import 'package:ez_tracker_app/providers/base_provider.dart';
import 'package:ez_tracker_app/services/firestore_service.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HomeProvider extends BaseProvider {
  LatLongModel? _latLongModel;
  LatLongModel? get latLongModel => _latLongModel;

  Future<void> getPosition() async {
    try {
      final Position position = await locationService.determinePosition();
      print("${position.latitude}  ${position.longitude}");
      _latLongModel =
          LatLongModel(lat: position.latitude, long: position.longitude);
      enabledLocationService = true;
      notifyListeners();
    } catch (error) {
      enabledLocationService = false;
      notifyListeners();
      UtilityHelper.showLog(error.toString());
    }
  }

  Stream<List<TrackerRecordModel>> getUnClassifiedRecords() {
    print('getUnClassifiedRecords');
    final now = DateTime.now();
    final startDate = (DateFormat('yyyy-MM-dd').format(DateTime(
      now.year,
      now.month,
    )));
    final endDate = (DateFormat('yyyy-MM-dd').format(DateTime(
      now.year,
      now.month + 1,
      0,
    )));

    UtilityHelper.showLog("StartDate: $startDate");
    UtilityHelper.showLog("EndDate: $endDate");
    return firestoreDBService.collectionStream<TrackerRecordModel>(
      path: FireStoreEndPoints.driveRecords,
      queryBuilder: (record) {
        return record
            .where(
              'status_id',
              isEqualTo: RecordStatusType.unclassified.id,
            )
            .where(
              "userid",
              isEqualTo: firebaseAuthService.currentUser()?.uid ?? '',
            )
            .orderBy('record_created_date')
            .startAt(
          [
            startDate,
          ],
        ).endAt(
          [
            endDate,
          ],
        );
      },
      builder: (data, recordId) {
        return TrackerRecordModel.fromMap(
          data as Map<String, dynamic>,
          recordId,
        );
      },
    );
  }

  Stream<List<TrackerRecordModel>> getClassifiedRecords() {
    final now = DateTime.now();
    final startDate = (DateFormat('yyyy-MM-dd').format(DateTime(
      now.year,
      now.month,
    )));
    final endDate = (DateFormat('yyyy-MM-dd').format(DateTime(
      now.year,
      now.month + 1,
      0,
    )));

    // UtilityHelper.showLog("StartDate: $startDate");
    // UtilityHelper.showLog("EndDate: $endDate");
    return firestoreDBService.collectionStream<TrackerRecordModel>(
      path: FireStoreEndPoints.driveRecords,
      queryBuilder: (record) {
        var non = '';
        return record
            .where(
              'status_id',
              isEqualTo: RecordStatusType.completed.id,
            )
            .where(
              "userid",
              isEqualTo: firebaseAuthService.currentUser()?.uid ?? '',
            )
            // .where(
            //   'primary_category',
            //   isEqualTo: 'personal',
            // )
            .where(
              'primary_category',
              whereIn: ['personal', 'business'],
            )
            .orderBy('record_created_date')
            .startAt(
          [
            startDate,
          ],
        ).endAt(
          [
            endDate,
          ],
        );
      },
      builder: (data, recordId) {
        return TrackerRecordModel.fromMap(
          data as Map<String, dynamic>,
          recordId,
        );
      },
    );
  }

  Future<void> prepareRecordAndUploadToFirestore() async {
    final recordId = const Uuid().v4();
    final userDetails = firebaseAuthService.currentUser();
    final record = TrackerRecordModel(
      recordCreatedDate: DateTime.now(),
      userId: userDetails?.uid,
      statusID: 2,
      sourceDetails: LatLongModel(
        createdDate: DateTime.now(),
        lat: _latLongModel?.lat,
        long: _latLongModel?.long,
      ),
      destinationDetails: LatLongModel(
        createdDate: DateTime.now(),
        lat: 72.969818,
        long: 23.597969,
      ),
    );

    await firestoreDBService
        .setData(
          path: '${FireStoreEndPoints.driveRecords}/$recordId',
          data: record.toMap(
            recordId: recordId,
          ),
          withMerge: true,
        )
        .whenComplete(() => print("data uploaded"));
  }
}
