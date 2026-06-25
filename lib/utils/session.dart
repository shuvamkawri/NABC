import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendee_model.dart';

/// Holds the currently logged-in attendee and persists it across app launches
/// so the user stays signed in until they explicitly log out.
///
/// Mirrors the static-class + [ValueNotifier] pattern used by
/// `ThemeController`. Screens can read [current] directly or listen via
/// [ValueListenableBuilder] on [attendee].
class Session {
  static const _key = 'session_attendee';

  static final ValueNotifier<Attendee?> attendee =
      ValueNotifier<Attendee?>(null);

  static Attendee? get current => attendee.value;

  static bool get isLoggedIn => attendee.value != null;

  /// Restores any persisted session. Call once during app startup before
  /// deciding which screen to show.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      attendee.value = Attendee.fromJson(map);
      debugPrint('🔐 [SESSION] restored: ${attendee.value?.fullName}');
    } catch (e) {
      debugPrint('🚨 [SESSION] failed to restore, clearing: $e');
      await prefs.remove(_key);
    }
  }

  static Future<void> signIn(Attendee value) async {
    attendee.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(value.toJson()));
    debugPrint('🔐 [SESSION] saved: ${value.fullName}');
  }

  static Future<void> signOut() async {
    attendee.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    debugPrint('🔐 [SESSION] cleared');
  }
}
