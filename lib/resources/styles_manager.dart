import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, FontWeight fontWeight, Color? color) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

// regular text style
TextStyle getRegularStyle({
  double? fontSize,
  required Color color,
}) {
  return _getTextStyle(
    fontSize ?? FontSize.s12,
    FontConstants.fontFamily,
    FontWeightManager.regular,
    color,
  );
}

// light text style
TextStyle getLightStyle({
  double? fontSize,
  required Color color,
}) {
  return _getTextStyle(
    fontSize ?? FontSize.s12,
    FontConstants.fontFamily,
    FontWeightManager.light,
    color,
  );
}

// bold text style
TextStyle getBoldStyle({
  double? fontSize,
  required Color color,
}) {
  return _getTextStyle(
    fontSize ?? FontSize.s12,
    FontConstants.fontFamily,
    FontWeightManager.bold,
    color,
  );
}

// semibold text style
TextStyle getSemiBoldStyle({
  double? fontSize,
  Color? color,
}) {
  return _getTextStyle(
    fontSize ?? FontSize.s12,
    FontConstants.fontFamily,
    FontWeightManager.semibold,
    color,
  );
}

// medium text style
TextStyle getMediumStyle({
  double? fontSize,
  required Color color,
}) {
  return _getTextStyle(
    fontSize ?? FontSize.s12,
    FontConstants.fontFamily,
    FontWeightManager.medium,
    color,
  );
}
