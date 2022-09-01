import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';

class AppBorderCardWidget extends StatelessWidget {
  const AppBorderCardWidget({
    Key? key,
    this.margin,
    this.padding,
    this.height,
    this.onTap,
    this.borderColor,
    this.borderWidth = 1.0,
    required this.child,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Widget child;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return onTap != null
        ? _buildClickableContainer(context)
        : _buildNormalContainer();
  }

  Widget _buildClickableContainer(BuildContext context) {
    return AppBorderCardWidget(
      margin: margin,
      padding: EdgeInsets.zero,
      child: Material(
        borderRadius: BorderRadius.all(
          Radius.circular(AppRadius.r15),
        ),
        child: InkWell(
          onTap: onTap,
          splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.all(
            Radius.circular(AppRadius.r15),
          ),
          child: Container(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildNormalContainer() {
    return Container(
      height: height,
      margin: margin,
      padding: padding ?? EdgeInsets.all(AppPadding.p16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            AppRadius.r15,
          ),
        ),
        border: Border.all(
          color: borderColor ?? ColorManager.lightGrey.withOpacity(0.4),
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}
