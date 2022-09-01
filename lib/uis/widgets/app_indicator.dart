import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';

class AppIndicator extends StatelessWidget {
  const AppIndicator({
    Key? key,
    this.indicatorColor,
  }) : super(key: key);
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: AppSize.s30,
        width: AppSize.s30,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            indicatorColor ?? ColorManager.white,
          ),
        ),
      ),
    );
  }
}
