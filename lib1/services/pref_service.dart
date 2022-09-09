import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefKeys {
  static String get driveRecord => 'driveRecord';
  // static String get isTrackingStarted => 'isTrackingStarted';
  static String get recordId => 'recordId';
}

class PreferenceService {
  PreferenceService._();
  static PreferenceService instance = PreferenceService._();

  Future<void> setBoolPrefValue({
    required String key,
    required bool value,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> getBoolPrefValue({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<void> setStringPrefValue({
    required String key,
    required String value,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getStringPrefValue({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  Future<void> setMapPrefValue({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedString = json.encode(value);
    prefs.setString(key, encodedString);
  }

  Future<Map<String, dynamic>?> getMapPrefValue({
    required String key,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String decodedString = prefs.getString(key) ?? '';
    return decodedString.isEmpty
        ? null
        : json.decode(decodedString) as Map<String, dynamic>?;
  }

  Future<void> setIntPrefValue({
    required String key,
    required int value,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<int> getIntPrefValue({
    required String key,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 2;
  }

  Future<bool> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Future<bool> value = prefs.clear();
    prefs.reload();
    return value;
  }
}
