import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class AppTheme {
  // ─── LIGHT ────────────────────────────────────────────────────────
  static ThemeData light() {
    // Light mode text palette — warm soft tones, not harsh black
    const heading     = Color(0xFF1C2B3A); // rich navy-dark, not pure black
    const body        = Color(0xFF374151); // comfortable dark grey
    const secondary   = Color(0xFF6B7280); // mid grey — clear but soft
    const subtle      = Color(0xFF9CA3AF); // placeholders / hints

    const cs = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.accentGold,
      onSecondary: Colors.white,
      error: AppColors.errorRed,
      onError: Colors.white,
      surface: Color(0xFFFFFFFF),
      onSurface: heading,
      surfaceContainerHighest: Color(0xFFF0F2F5),
      outline: Color(0xFFDDE1E7),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,
      scaffoldBackgroundColor: const Color(0xFFF2F5F8),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFDDE1E7),
      shadowColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: EdgeInsets.zero,
        shadowColor: Colors.black12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE1E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        hintStyle: TextStyle(color: subtle),
        labelStyle: TextStyle(color: secondary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEEF2F7),
        selectedColor: AppColors.primaryBlue,
        labelStyle: TextStyle(fontSize: 13, color: body),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 13),
      ),
      textTheme: TextTheme(
        // Headings
        displayLarge:  TextStyle(color: heading, fontWeight: FontWeight.w900, fontSize: 32),
        displayMedium: TextStyle(color: heading, fontWeight: FontWeight.w800, fontSize: 28),
        displaySmall:  TextStyle(color: heading, fontWeight: FontWeight.w700, fontSize: 24),
        headlineLarge: TextStyle(color: heading, fontWeight: FontWeight.w800, fontSize: 22),
        headlineMedium:TextStyle(color: heading, fontWeight: FontWeight.w700, fontSize: 20),
        headlineSmall: TextStyle(color: heading, fontWeight: FontWeight.w700, fontSize: 18),
        // Titles
        titleLarge:  TextStyle(color: heading, fontWeight: FontWeight.w800, fontSize: 17),
        titleMedium: TextStyle(color: heading, fontWeight: FontWeight.w700, fontSize: 15),
        titleSmall:  TextStyle(color: heading, fontWeight: FontWeight.w600, fontSize: 13),
        // Body
        bodyLarge:  TextStyle(color: body, fontSize: 15, height: 1.55),
        bodyMedium: TextStyle(color: body, fontSize: 14, height: 1.5),
        bodySmall:  TextStyle(color: secondary, fontSize: 12, height: 1.45),
        // Labels
        labelLarge:  TextStyle(color: heading, fontWeight: FontWeight.w600, fontSize: 13),
        labelMedium: TextStyle(color: secondary, fontSize: 12),
        labelSmall:  TextStyle(color: subtle,    fontSize: 11),
      ),
    );
  }

  // ─── DARK ─────────────────────────────────────────────────────────
  static ThemeData dark() {
    // Dark mode text palette — warm whites, never glaring
    const heading   = Color(0xFFECEFF4); // soft white — crisp but not glaring
    const body      = Color(0xFFCDD5E0); // comfortable light grey
    const secondary = Color(0xFF8D99AE); // visible secondary text
    const subtle    = Color(0xFF5C6472); // hints / placeholders

    const cs = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.lightBlue,
      onPrimary: Colors.black,
      secondary: AppColors.accentGold,
      onSecondary: Colors.black,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      surface: Color(0xFF1E2430),
      onSurface: heading,
      surfaceContainerHighest: Color(0xFF252D3A),
      outline: Color(0xFF374151),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: const Color(0xFF131922),
      cardColor: const Color(0xFF1E2430),
      dividerColor: const Color(0xFF374151),
      shadowColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF161E2A),
        foregroundColor: Color(0xFFECEFF4),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFECEFF4)),
        actionsIconTheme: IconThemeData(color: Color(0xFFECEFF4)),
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: Color(0xFFECEFF4),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E2430),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightBlue,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightBlue,
          side: const BorderSide(color: AppColors.lightBlue),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.lightBlue),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF252D3A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        hintStyle: TextStyle(color: subtle),
        labelStyle: TextStyle(color: secondary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E2430),
        selectedItemColor: AppColors.lightBlue,
        unselectedItemColor: Color(0xFF5C6472),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF252D3A),
        selectedColor: AppColors.primaryBlue,
        labelStyle: TextStyle(fontSize: 13, color: body),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 13),
      ),
      textTheme: TextTheme(
        // Headings
        displayLarge:  TextStyle(color: heading, fontWeight: FontWeight.w900, fontSize: 32),
        displayMedium: TextStyle(color: heading, fontWeight: FontWeight.w800, fontSize: 28),
        displaySmall:  TextStyle(color: heading, fontWeight: FontWeight.w700, fontSize: 24),
        headlineLarge: TextStyle(color: heading, fontWeight: FontWeight.w800, fontSize: 22),
        headlineMedium:TextStyle(color: heading, fontWeight: FontWeight.w700, fontSize: 20),
        headlineSmall: TextStyle(color: heading, fontWeight: FontWeight.w700, fontSize: 18),
        // Titles
        titleLarge:  TextStyle(color: heading, fontWeight: FontWeight.w800, fontSize: 17),
        titleMedium: TextStyle(color: heading, fontWeight: FontWeight.w700, fontSize: 15),
        titleSmall:  TextStyle(color: heading, fontWeight: FontWeight.w600, fontSize: 13),
        // Body
        bodyLarge:  TextStyle(color: body, fontSize: 15, height: 1.55),
        bodyMedium: TextStyle(color: body, fontSize: 14, height: 1.5),
        bodySmall:  TextStyle(color: secondary, fontSize: 12, height: 1.45),
        // Labels
        labelLarge:  TextStyle(color: heading,   fontWeight: FontWeight.w600, fontSize: 13),
        labelMedium: TextStyle(color: secondary, fontSize: 12),
        labelSmall:  TextStyle(color: subtle,    fontSize: 11),
      ),
    );
  }
}