import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF0A0A0A);
  static const bg2 = Color(0xFF111111);
  static const bg3 = Color(0xFF181818);

  static const text = Color(0xFFFFFFFF);
  static const text2 = Color(0xA6FFFFFF); // 0.65
  static const text3 = Color(0x66FFFFFF); // 0.40

  static const border = Color(0x14FFFFFF);  // 0.08
  static const border2 = Color(0x24FFFFFF); // 0.14

  static const accent = Color(0xFF00FFA3);
  static const accent2 = Color(0xFF7C3AED);
  static const accentGlow = Color(0x2600FFA3);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [accent, accent2],
  );
}

class AppText {
  static TextStyle get _inter => GoogleFonts.inter(color: AppColors.text);
  static TextStyle get _mono => GoogleFonts.jetBrainsMono(color: AppColors.text);

  static TextStyle get h1 => _inter.copyWith(
        fontSize: 64, fontWeight: FontWeight.w800, height: 1.05, letterSpacing: -2.5,
      );
  static TextStyle get h2 => _inter.copyWith(
        fontSize: 44, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1.4,
      );
  static TextStyle get h4 => _inter.copyWith(
        fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.2,
      );
  static TextStyle get h6 => _inter.copyWith(
        fontSize: 18, fontWeight: FontWeight.w700,
      );
  static TextStyle get body => _inter.copyWith(
        fontSize: 16, fontWeight: FontWeight.w400, height: 1.6,
      );
  static TextStyle get label => _inter.copyWith(
        fontSize: 14, fontWeight: FontWeight.w500,
      );
  static TextStyle get mono => _mono.copyWith(
        fontSize: 13, fontWeight: FontWeight.w500,
      );
}

ThemeData oligonTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    primaryColor: AppColors.accent,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accent2,
      surface: AppColors.bg,
      onPrimary: AppColors.bg,
    ),
  );
}
