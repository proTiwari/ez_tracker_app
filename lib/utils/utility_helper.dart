import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:connectivity/connectivity.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/strings_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UtilityHelper {
  static void showLog(String value) {
    log(value);
  }

  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > (x1 ?? 0)) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > (y1 ?? 0)) y1 = latLng.longitude;
        if (latLng.longitude < (y0 ?? 0)) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1 ?? 0, y1 ?? 0),
        southwest: LatLng(x0 ?? 0, y0 ?? 0));
  }

  static String distanceInMiles({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    var p = 0.017453292519943295; // Math.PI / 180
    var c = math.cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 *
            math.asin(
              math.sqrt(a),
            ) *
            0.621371)
        .toStringAsFixed(1); // 2 * R; R = 6371 km => 1Km = 0.621371;
  }

  static Future<bool> checkInternet() async {
    try {
      final ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      final bool result = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      return result;
    } on SocketException catch (_) {
      return false;
    }
  }

  static void showToast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: FontSize.s16,
    );
  }

  static Widget showNoDataWidget({String? message}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p25),
        child: Text(
          message ?? AppStrings.kNoDataFound,
          style: getBoldStyle(
            fontSize: FontSize.s20,
            color: ColorManager.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
