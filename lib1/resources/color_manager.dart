import 'package:flutter/material.dart';

class ColorManager {
  static const Color scaffoldBg = Color(0xFFF0F0F0);

  static const Color primary = Color(0xFF3f75bb);
  static Color primaryOpacity70 = const Color(0xFF3f75bb).withOpacity(0.7);
  static const Color darkPrimary = Color(0xFF1c3766);
  static const Color accent = Color(0xFFC0B550);
  static Color accentOpacity70 = const Color(0xFFC0B550).withOpacity(0.7);

  static const Color darkGrey = Color(0xFF525252);
  static const Color grey = Color(0xFF737477);
  static const Color lightGrey = Color(0xFF9E9E9E);

  static const Color grey1 = Color(0xFF707070);
  static const Color grey2 = Color(0xFF797979);

  static const Color error = Color(0xFFE61F34);

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color green = Color(0xFF0C8F19);
  static const Color red = Color(0xFFD71010);
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF' + hexColorString; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
