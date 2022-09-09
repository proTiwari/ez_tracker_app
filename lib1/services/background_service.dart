// import 'dart:ui';

// import 'package:ez_tracker_app/services/pref_service.dart';
// import 'package:ez_tracker_app/services/sensor_plus_service.dart';
// import 'package:ez_tracker_app/utils/utility_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

// // to ensure this is executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// bool onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();
//   UtilityHelper.showLog('FLUTTER BACKGROUND FETCH');
//   service.on('update').listen((event) {
//     SensorPlusService.instance.initLocationTrackingEvent();
//   });
//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();

//   /// you can see this log in logcat
//   UtilityHelper.showLog('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//   service.on('update').listen((event) {
//     SensorPlusService.instance.initLocationTrackingEvent();
//   });
// }

// class BackgroundService {
//   const BackgroundService._();

//   static const instance = BackgroundService._();

//   Future<void> init() async {
//     final service = FlutterBackgroundService();
//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         // this will be executed when app is in foreground or background in separated isolate
//         onStart: onStart,
//         // auto start service
//         autoStart: false,
//         isForegroundMode: true,
//       ),
//       iosConfiguration: IosConfiguration(
//         // auto start service
//         autoStart: false,
//         // this will be executed when app is in foreground in separated isolate
//         onForeground: onStart,
//         // you have to enable background fetch capability on xcode project
//         onBackground: onIosBackground,
//       ),
//     );
//     service.startService();
//   }

//   Future<void> initUserTracking(bool isLocationEnabled) async {
//     UtilityHelper.showLog('initUserTracking: Called**');
//     if (isLocationEnabled) {
//       final service = FlutterBackgroundService();
//       final isTrackingStarted = await PreferenceService.instance
//           .getBoolPrefValue(key: PrefKeys.isTrackingStarted);
//       if (isTrackingStarted) return;
//       final isRunning = await service.isRunning();
//       if (isRunning) {
//         UtilityHelper.showLog('BackGround Service is running');
//         service.invoke('update');
//       } else {
//         await service.startService();
//         service.invoke('update');
//         UtilityHelper.showLog('BackGround Service is not running, So started');
//       }
//     } else {
//       PreferenceService.instance
//           .setBoolPrefValue(value: false, key: PrefKeys.isTrackingStarted);
//     }
//   }
// }
