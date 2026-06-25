import 'package:flutter/material.dart';

extension Responsive on BuildContext {
  // ─── Screen dimensions ────────────────────────────────────────
  double get sw => MediaQuery.of(this).size.width;
  double get sh => MediaQuery.of(this).size.height;
  double get shortestSide => MediaQuery.of(this).size.shortestSide;

  // ─── Breakpoints ──────────────────────────────────────────────
  bool get isSmall => sw < 360;
  bool get isMedium => sw >= 360 && sw < 480;
  bool get isLarge => sw >= 480;
  bool get isTablet => shortestSide >= 600;

  // ─── Percentage helpers ───────────────────────────────────────
  double wp(double pct) => sw * pct / 100;
  double hp(double pct) => sh * pct / 100;

  // ─── Scaled font size (base 390w) ────────────────────────────
  double sp(double size) => size * (sw / 390).clamp(0.78, 1.25);

  // ─── Adaptive padding / spacing ───────────────────────────────
  double get pagePad => isSmall ? 12.0 : isTablet ? 24.0 : 16.0;
  double get cardPad => isSmall ? 10.0 : 14.0;
  double get cardRadius => isSmall ? 10.0 : 14.0;
  EdgeInsets get pageInsets => EdgeInsets.all(pagePad);

  // ─── Adaptive grid count ──────────────────────────────────────
  int get gridCount3 => isTablet ? 4 : isLarge ? 3 : isSmall ? 2 : 3;
  int get gridCount2 => isTablet ? 3 : 2;

  // ─── Carousel / banner height ─────────────────────────────────
  double get bannerH => hp(isSmall ? 25 : isTablet ? 35 : 28);
  double get splashH => sh;

  // ─── Adaptive icon size ───────────────────────────────────────
  double get iconSm => isSmall ? 16.0 : 18.0;
  double get iconMd => isSmall ? 20.0 : 24.0;
  double get iconLg => isSmall ? 28.0 : 32.0;

  // ─── Dark mode ────────────────────────────────────────────────
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ─── Theme-aware colors ───────────────────────────────────────
  Color get cardBg => Theme.of(this).cardColor;
  Color get scaffoldBg => Theme.of(this).scaffoldBackgroundColor;
  Color get surfaceBg => Theme.of(this).colorScheme.surfaceContainerHighest;
  Color get textPrimary => Theme.of(this).colorScheme.onSurface;
  Color get textSecondary => isDark
      ? const Color(0xFF8D99AE)  // dark mode — matches app_theme.dart secondary
      : const Color(0xFF6B7280); // light mode — matches app_theme.dart secondary
  Color get borderColor => Theme.of(this).dividerColor;
  Color get shadowClr =>
      isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.07);
  Color get inputFill => isDark
      ? Theme.of(this).colorScheme.surfaceContainerHighest
      : Colors.white;

  // ─── Adaptive box shadow ──────────────────────────────────────
  List<BoxShadow> get cardShadow => isDark
      ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ]
      : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ];
}