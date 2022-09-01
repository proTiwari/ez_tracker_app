import 'package:ez_tracker_app/uis/widgets/app_indicator.dart';
import 'package:flutter/material.dart';

class AppRectangleButton extends StatelessWidget {
  const AppRectangleButton({
    Key? key,
    this.width,
    this.margin = EdgeInsets.zero,
    this.textStyle,
    this.isEnabled = true,
    this.isLoading = false,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final double? width;

  final EdgeInsetsGeometry margin;
  final String title;
  final TextStyle? textStyle;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: margin,
      child: AbsorbPointer(
        absorbing: !isEnabled,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          child: isLoading
              ? const AppIndicator()
              : Text(
                  title,
                  style: textStyle,
                ),
        ),
      ),
    );
  }
}
