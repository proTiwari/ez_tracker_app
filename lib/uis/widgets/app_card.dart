import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:flutter/material.dart';
import '/resources/values_manager.dart';

class AppCard extends StatelessWidget {
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  const AppCard({
    Key? key,
    this.bgColor,
    this.padding,
    this.width,
    required this.child,
    this.margin,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      padding: padding ?? EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).primaryColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.r10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: ColorManager.black.withOpacity(0.2),
            blurRadius: AppRadius.r2,
            spreadRadius: AppRadius.r2,
          ),
        ],
      ),
      child: child,
    );
  }
}
