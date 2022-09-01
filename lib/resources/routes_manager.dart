import 'package:ez_tracker_app/resources/strings_manager.dart';
import 'package:ez_tracker_app/uis/screens/home/home_screen.dart';
import 'package:ez_tracker_app/uis/screens/login/login_screen.dart';
import 'package:ez_tracker_app/uis/screens/map_details/map_details_screen.dart';
import 'package:ez_tracker_app/uis/screens/my_activity/my_activity_screen.dart';
import 'package:ez_tracker_app/uis/screens/signup/sign_up_screen.dart';
import 'package:ez_tracker_app/uis/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String myActivityRoute = '/my-activity';
  static const String mapDetailsRoute = '/map-details';

  static void popUntil(
    BuildContext context, {
    required String name,
    Object? arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      name,
      (_) => false,
      arguments: arguments,
    );
  }

  static void popTo(BuildContext context, {required String name}) {
    Navigator.of(context).popUntil(ModalRoute.withName(name));
  }
}

class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.splashRoute:
        return _buildRouteScreen(
          name: routeSettings.name,
          child: const SplashScreen(),
        );
      case AppRoutes.loginRoute:
        return _buildRouteScreen(
          name: routeSettings.name,
          child: const LoginScreen(),
        );
      case AppRoutes.signupRoute:
        return _buildRouteScreen(
          name: routeSettings.name,
          child: const SignUpScreen(),
        );
      case AppRoutes.homeRoute:
        return _buildRouteScreen(
          name: routeSettings.name,
          child: const HomeScreen(),
        );
      case AppRoutes.myActivityRoute:
        return _buildRouteScreen(
          name: routeSettings.name,
          child: const MyActivityScreen(),
        );
      case AppRoutes.mapDetailsRoute:
        return _buildRouteScreen(
          name: routeSettings.name,
          child: MapDetailsScreen(
            routeModel: routeSettings.arguments as MapDetailsRouteModel,
          ),
        );
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return _buildRouteScreen(
      child: const Scaffold(
        body: Center(
          child: Text(AppStrings.kNoRouteFound),
        ),
      ),
    );
  }

  static MaterialPageRoute<dynamic> _buildRouteScreen({
    String? name,
    required Widget child,
  }) {
    return MaterialPageRoute<dynamic>(
      settings: RouteSettings(name: name),
      builder: (_) => child,
    );
  }
}
