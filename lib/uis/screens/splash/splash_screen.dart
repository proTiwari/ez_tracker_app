import 'package:ez_tracker_app/providers/account_provider.dart';
import 'package:ez_tracker_app/resources/assets_manager.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/routes_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:ez_tracker_app/uis/widgets/app_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: DurationConst.d2),
      navigationPage,
    );
  }

  Future<void> navigationPage() async {
    final AccountProvider accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    final hasData = await accountProvider.checkFirebaseUserAndFetchData();
    // await accountProvider.getCategoriesData();
    if (hasData) {
      AppRoutes.popUntil(context, name: AppRoutes.homeRoute);
    } else {
      AppRoutes.popUntil(context, name: AppRoutes.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImageAssets.appLogo,
          fit: BoxFit.fill,
          width: AppWidth.w80Percent,
        ),
        SizedBox(height: AppHeight.h20),
        const AppIndicator(
          indicatorColor: ColorManager.primary,
        ),
      ],
    ));
  }
}
