import 'dart:convert';

import 'package:ez_tracker_app/models/tracker_record/tracker_record_model.dart';
import 'package:ez_tracker_app/providers/base_provider.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../helpers/constant.dart';
import '../models/tracker_record/location_detail_model.dart';
import '../services/firestore_service.dart';

class RecordTileProvider extends BaseProvider {
  TrackerRecordModel? trackerRecordDetails;
  RecordTileProvider({required this.trackerRecordDetails}) {
    prepareInitialData();
  }

  bool loading = false;
  bool get isLoading => loading;

  LocationDetailsModel _sourceLocationDetails = LocationDetailsModel();
  LocationDetailsModel get sourceLocationDetails => _sourceLocationDetails;

  LocationDetailsModel _destinationLocationDetails = LocationDetailsModel();
  LocationDetailsModel get destinationLocationDetails =>
      _destinationLocationDetails;

  void setLoading(progress) {
    loading = progress;
    notifyListeners();
  }

  String get recordWeekDay => trackerRecordDetails?.recordCreatedDate != null
      ? DateFormat('EEE').format(trackerRecordDetails!.recordCreatedDate!)
      : '';

  Future<void> prepareInitialData() async {
    await prepareSourceLocationDetails();
    await prepareDestinationLocationDetails();
    setLoading(false);
  }

  Future<void> prepareSourceLocationDetails() async {
    final address = await getAddress(
      trackerRecordDetails?.sourceDetails?.lat,
      trackerRecordDetails?.sourceDetails?.long,
    );
    final time = getTime(trackerRecordDetails?.sourceDetails?.createdDate);
    _sourceLocationDetails =
        _sourceLocationDetails.copyWith(address: address, time: time);
    UtilityHelper.showLog('Time: $time, Address $address');
    notifyListeners();
  }

  Future<void> prepareDestinationLocationDetails() async {
    final address = await getAddress(
      trackerRecordDetails?.destinationDetails?.lat,
      trackerRecordDetails?.destinationDetails?.long,
    );
    final time = getTime(trackerRecordDetails?.destinationDetails?.createdDate);
    _destinationLocationDetails =
        _destinationLocationDetails.copyWith(address: address, time: time);
    UtilityHelper.showLog('Time: $time, Address $address');
    notifyListeners();
  }

  // Future<String> getAddress(double? lat, double? long) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(lat ?? 0, long ?? 0);
  //   Placemark place = placemarks[0];
  //   UtilityHelper.showLog('Place Marks ${placemarks.toString()}');
  //   return place.postalCode ?? '';
  // }

  Future<String> getAddress(double? lat, double? lng) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$googleMapApiKey&language=en&latlng=$lat,$lng';
    if (lat != null && lng != null) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        UtilityHelper.showLog("response ==== $_formattedAddress");
        return _formattedAddress;
      }
      return '';
    } else {
      return '';
    }
  }

  String getTime(DateTime? dateTime) {
    return dateTime != null ? DateFormat('hh:mm a').format(dateTime) : '';
  }

  // Firestore function
  Future<void> updateRatings(double ratings) async {
    final userDetails = firebaseAuthService.currentUser();
    final record = TrackerRecordModel(
      ratings: ratings,
      userId: userDetails?.uid,
      statusID: (trackerRecordDetails?.subCategory != null)
          ? RecordStatusType.completed.id
          : RecordStatusType.unclassified.id,
    );
    await firestoreDBService.setData(
      path: FireStoreEndPoints.driveRecords +
          '/${trackerRecordDetails?.recordId}',
      data: record.toMap(
        recordId: trackerRecordDetails?.recordId ?? '',
      ),
      withMerge: true,
    );
    trackerRecordDetails = trackerRecordDetails?.copyWith(ratings: ratings);
    notifyListeners();
  }

  // Firestore function
  Future<void> updateCategory({
    String? primary,
    String? subCategory,
  }) async {
    final userDetails = firebaseAuthService.currentUser();
    final record = TrackerRecordModel(
      userId: userDetails?.uid,
      primaryCategory: primary,
      subCategory: subCategory,
      statusID: (trackerRecordDetails?.ratings != null &&
              trackerRecordDetails?.ratings != 0)
          ? RecordStatusType.completed.id
          : RecordStatusType.unclassified.id,
    );
    await firestoreDBService.setData(
      path: FireStoreEndPoints.driveRecords +
          '/${trackerRecordDetails?.recordId}',
      data: record.toMap(
        recordId: trackerRecordDetails?.recordId ?? '',
      ),
      withMerge: true,
    );
    trackerRecordDetails = trackerRecordDetails?.copyWith(
        primaryCategory: primary, subCategory: subCategory);
    notifyListeners();
  }
}
