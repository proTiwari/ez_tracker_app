import 'package:ez_tracker_app/resources/routes_manager.dart';
import 'package:ez_tracker_app/uis/widgets/app_card.dart';
import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key}) : super(key: key);

  static void show() {
    if (RouteGenerator.navigatorKey.currentContext != null) {
      showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        context: RouteGenerator.navigatorKey.currentContext!,
        builder: (context) => const AppProgressIndicator(),
      );
    }
  }

  static void dismiss() {
    if (RouteGenerator.navigatorKey.currentContext != null) {
      Navigator.of(RouteGenerator.navigatorKey.currentContext!).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCard(
              padding: EdgeInsets.all(AppPadding.p30),
              bgColor: ColorManager.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: AppSize.s25,
                    height: AppSize.s25,
                    child: const CircularProgressIndicator(),
                  ),
                  SizedBox(width: AppWidth.w15),
                  Text(
                    AppStrings.kPleaseWait,
                    style: getRegularStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s17,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
