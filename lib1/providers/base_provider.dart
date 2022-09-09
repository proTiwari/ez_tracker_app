import 'package:ez_tracker_app/services/firestore_service.dart';
import 'package:ez_tracker_app/services/auth_service.dart';
import 'package:ez_tracker_app/services/location_service.dart';
import 'package:ez_tracker_app/services/pref_service.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BaseProvider with ChangeNotifier {
  final firebaseAuthService = AuthService.instance;
  final firestoreDBService = FireStoreService.instance;
  final locationService = LocationService.instance;
  final preferenceService = PreferenceService.instance;

  bool? enabledLocationService;
  bool? get isLocationServiceEnabled => enabledLocationService;

  Future<void> checkLocationServiceEnabled() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      enabledLocationService = false;
      notifyListeners();
    } else if (permission == LocationPermission.deniedForever) {
      enabledLocationService = false;
      notifyListeners();
    } else {
      enabledLocationService = true;
      notifyListeners();
    }
    UtilityHelper.showLog('IsLocationEnabled: $isLocationServiceEnabled');
  }
}
