import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF09090B);
  static const Color backgroundSecondary = Color(0xFF121215);
  static const Color surfaceDark = Color(0xFF161619);
  static const Color surfaceDarkBorder = Color(0xFF28282D);
  static const Color primaryRed = Color(0xFFE52828);
  static const Color primaryRedDark = Color(0xFF8A1E24);
  static const Color primaryRedTint = Color(0xFF331417);
  static const Color primaryRedGlow = Color(0x33E52828);

  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color cardTrackGray = Color(0xFFF1F2F6);
  static const Color cardPillDark = Color(0xFF141416);

  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8E8E93);
  static const Color textSecondary = Color(0xFFA0A0A8);
  static const Color textDark = Color(0xFF141416);
  static const Color textDarkSecondary = Color(0xFF71717A);
}

class AppStyles {
  static SmoothBorderRadius squircleRadius(double radius, [double smoothing = 0.6]) {
    return SmoothBorderRadius(
      cornerRadius: radius,
      cornerSmoothing: smoothing,
    );
  }

  static SmoothRectangleBorder squircleBorder({
    double radius = 16,
    double smoothing = 0.6,
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
  }) {
    return SmoothRectangleBorder(
      borderRadius: squircleRadius(radius, smoothing),
      side: borderWidth > 0
          ? BorderSide(color: borderColor, width: borderWidth)
          : BorderSide.none,
    );
  }

  static ShapeDecoration squircleDecoration({
    required Color color,
    double radius = 16,
    double smoothing = 0.6,
    Color? borderColor,
    double borderWidth = 1.0,
    List<BoxShadow>? shadows,
  }) {
    return ShapeDecoration(
      color: color,
      shadows: shadows,
      shape: SmoothRectangleBorder(
        borderRadius: squircleRadius(radius, smoothing),
        side: borderColor != null
            ? BorderSide(color: borderColor, width: borderWidth)
            : BorderSide.none,
      ),
    );
  }

  static TextStyle heading({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.textWhite,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle body({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textMuted,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}

