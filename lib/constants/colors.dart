import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color lightBlue = Color(0xFF42A5F5);

  // Accent Colors
  static const Color accentGold = Color(0xFFFFB300);
  static const Color accentOrange = Color(0xFFFF9100);
  static const Color accentRed = Color(0xFFD32F2F);

  // Neutral Colors — softened for eye comfort
  static const Color darkGrey = Color(0xFF2D2D2D);   // was 0xFF212121 (too harsh)
  static const Color mediumGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color veryLightGrey = Color(0xFFFAFAFA);

  // Background Colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF5F5F5);

  // Status Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color errorRed = Color(0xFFE53935);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF1565C0),
    Color(0xFF0D47A1),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFFFB300),
    Color(0xFFFF9100),
  ];
}