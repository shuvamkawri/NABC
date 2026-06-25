import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/attendee_model.dart';
import '../models/food_booking_model.dart';
import '../models/hotel_booking_model.dart';

/// Thrown when the API responds but the lookup did not succeed
/// (e.g. no attendee matches the given phone number).
class AttendeeException implements Exception {
  final String message;
  AttendeeException(this.message);
  @override
  String toString() => message;
}

/// Web edition of the attendee service.
///
/// The mobile app calls the backend with **GET-with-a-body**, which browsers
/// cannot send. This web build instead sends a normal **POST** with the same
/// JSON payload. The endpoint is configurable via `--dart-define=API_BASE=...`:
///
///   • default  → the backend directly (`http://45.79.175.205:3000/api-attendee`).
///                Works for `flutter run -d chrome` (http page → http API is
///                allowed) once the backend accepts POST. CORS is already `*`.
///   • `/api`   → the bundled Dart proxy on the same origin (see bin/server.dart).
///                Use this for production / HTTPS hosting, where the browser
///                blocks the plain-http backend (mixed content). The proxy also
///                works even if the backend still only accepts GET-with-body.
class AttendeeService {
  static const String _apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://45.79.175.205:3000/api-attendee',
  );

  /// Looks up an attendee by phone number, trying the common US formats the
  /// backend may have stored until one matches.
  static Future<Attendee> findByPhone(String input) async {
    final candidates = _phoneCandidates(input);
    debugPrint('🔐 [LOGIN] will try ${candidates.length} format(s): $candidates');

    for (var i = 0; i < candidates.length; i++) {
      final phone = candidates[i];
      debugPrint('🔐 [LOGIN] attempt ${i + 1}/${candidates.length} → "$phone"');
      final attendee = await _lookup(phone);
      if (attendee != null) {
        debugPrint('✅ [LOGIN] MATCH → ${attendee.fullName} '
            '(reg=${attendee.registrationNumber})');
        return attendee;
      }
    }

    debugPrint('❌ [LOGIN] no format matched for "$input"');
    throw AttendeeException('No registration found for this phone number.');
  }

  static Future<Attendee?> _lookup(String phone) async {
    final res = await _post('find-attendee', {'phone': phone}, tag: 'LOGIN');

    final body = _decode(res.body);
    if (res.statusCode == 200 && body?['data'] is Map<String, dynamic>) {
      return Attendee.fromJson(body!['data'] as Map<String, dynamic>);
    }

    final serverMsg = body?['message']?.toString();
    if (_isNotFound(res.statusCode, serverMsg)) return null;

    throw AttendeeException(
      serverMsg != null && serverMsg.isNotEmpty && serverMsg != 'success'
          ? serverMsg
          : 'Login failed. Please try again.',
    );
  }

  /// Fetches the hotel/accommodation bookings for a registration number.
  static Future<List<HotelBooking>> findHotels(String registrationNumber) async {
    final rows = await _lookupList(
        'find-attendee-hotel', {'registration_number': registrationNumber},
        tag: 'HOTEL');
    return rows.map(HotelBooking.fromJson).toList();
  }

  /// Fetches the food bookings for a registration number.
  static Future<List<FoodBooking>> findFood(String registrationNumber) async {
    final rows = await _lookupList(
        'find-attendee-food', {'registration_number': registrationNumber},
        tag: 'FOOD');
    return rows.map(FoodBooking.fromJson).toList();
  }

  static Future<List<Map<String, dynamic>>> _lookupList(
    String path,
    Map<String, dynamic> payload, {
    required String tag,
  }) async {
    final res = await _post(path, payload, tag: tag);

    final body = _decode(res.body);
    if (res.statusCode == 200 && body?['data'] is List) {
      final list =
          (body!['data'] as List).whereType<Map<String, dynamic>>().toList();
      debugPrint('✅ [$tag] ${list.length} record(s)');
      return list;
    }

    final serverMsg = body?['message']?.toString();
    if (_isNotFound(res.statusCode, serverMsg)) return const [];

    throw AttendeeException('Could not load data. Please try again.');
  }

  /// Sends one POST request with a JSON body and returns the response.
  static Future<http.Response> _post(
      String path, Map<String, dynamic> payload,
      {required String tag}) async {
    final uri = Uri.parse('$_apiBase/$path');
    debugPrint('🌐 [$tag] POST $uri  body=${jsonEncode(payload)}');
    try {
      final res = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(payload))
          .timeout(const Duration(seconds: 20));
      debugPrint('🌐 [$tag] status: ${res.statusCode}');
      return res;
    } catch (e) {
      debugPrint('🚨 [$tag] network error: $e');
      throw AttendeeException(
          'Unable to reach the server. Please check your connection and try again.');
    }
  }

  static Map<String, dynamic>? _decode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  /// The backend signals "no match" with 400 {message:"fail"} or 404; an empty
  /// 200 is also treated as no-match so the caller can try the next candidate.
  static bool _isNotFound(int status, String? serverMsg) =>
      status == 404 ||
      status == 200 ||
      (status == 400 && serverMsg == 'fail');

  /// Builds the ordered list of phone strings to try for a US number.
  static List<String> _phoneCandidates(String input) {
    final trimmed = input.trim();
    var digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('1')) {
      digits = digits.substring(1);
    }

    final candidates = <String>[];
    if (digits.length == 10) {
      final area = digits.substring(0, 3);
      final pre = digits.substring(3, 6);
      final line = digits.substring(6, 10);
      candidates.addAll([
        '+1 $area-$pre-$line',
        '+1$digits',
        '+1 $digits',
        '($area) $pre-$line',
        '$area-$pre-$line',
        digits,
      ]);
    }
    if (trimmed.isNotEmpty && !candidates.contains(trimmed)) {
      candidates.add(trimmed);
    }
    return candidates;
  }
}