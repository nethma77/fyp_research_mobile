import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A237E);
  static const Color secondary = Color(0xFFF59E0B);
  static const Color background = Color(0xFFF3F6F8);
  static const Color text = Color(0xFF1F2937);
  static const Color mutedText = Color(0xFF6B7280);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFD1D9E2);
  static const Color error = Color(0xFFE53935);
}

class AppStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: 0.2,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.text,
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    color: AppColors.mutedText,
  );
}

class AppConstants {
  static const double defaultPadding = 20.0;
  static const double borderRadius = 18.0;
}
