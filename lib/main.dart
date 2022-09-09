import 'package:ez_tracker_app/providers/account_provider.dart';
import 'package:ez_tracker_app/providers/home_provider.dart';
import 'package:ez_tracker_app/resources/theme_manager.dart';
import 'package:ez_tracker_app/services/background_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'resources/routes_manager.dart';
import 'resources/strings_manager.dart';

// global RouteObserver
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
const initialAppScreenSize = Size(375, 812);

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundService.instance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(const EZTrackerApp());
}

class EZTrackerApp extends StatelessWidget {
  const EZTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: initialAppScreenSize,
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.kEZTracker,
          theme: getApplicationTheme(),
          onGenerateRoute: RouteGenerator.getRoute,
          navigatorObservers: <NavigatorObserver>[routeObserver],
          navigatorKey: RouteGenerator.navigatorKey,
        ),
      ),
    );
  }
}
