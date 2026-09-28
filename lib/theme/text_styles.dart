import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class ThemeTextStyles {
  static Color _getDefaultColor({bool? isDark}) {
    return isDark == true ? Colors.white : Colors.black;
  }

  static TextStyle title1SemiBold({
    Color? color,
    FontWeight? fontWeight = FontWeight.w600,
    bool? isDark,
  }) {
    return GoogleFonts.manrope(
      fontSize: 24,
      fontWeight: fontWeight,
      color: color ?? _getDefaultColor(isDark: isDark),
    );
  }

  static TextStyle title3SemiBold({
    Color? color,
    FontWeight? fontWeight = FontWeight.w300,
    bool? isDark,
  }) {
    return GoogleFonts.manrope(
      fontSize: 17,
      fontWeight: fontWeight,
      color: color ?? _getDefaultColor(isDark: isDark),
    );
  }

  static TextStyle caption({
    Color? color,
    FontWeight? fontWeight = FontWeight.w400,
    bool? isDark,
  }) {
    return GoogleFonts.manrope(
      fontSize: 12,
      fontWeight: fontWeight,
      color: color ?? _getDefaultColor(isDark: isDark),
    );
  }
}
