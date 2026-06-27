import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Web edition — submits a support/feedback ticket to
/// `POST /api-attendee/create-feedback`, using the same `API_BASE` as the
/// other web services. The photo is sent as a base64 data URL; the server
/// saves it and stores the path. Latitude/longitude are optional strings.
class FeedbackService {
  static const String _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://45.79.175.205:3000/api-attendee',
  );

  static Future<String> submit({
    required String registrationNumber,
    required String fullName,
    required String category,
    required String subject,
    required String message,
    String? photoBase64,
    String? latitude,
    String? longitude,
  }) async {
    final uri = Uri.parse('$_base/create-feedback');
    final payload = {
      'registration_number': registrationNumber,
      'full_name': fullName,
      'category': category,
      'subject': subject,
      'message': message,
      if (photoBase64 != null && photoBase64.isNotEmpty) 'photo': photoBase64,
      if (latitude != null && latitude.isNotEmpty) 'latitude': latitude,
      if (longitude != null && longitude.isNotEmpty) 'longitude': longitude,
    };
    debugPrint('🟢 [FEEDBACK] POST $uri  reg=$registrationNumber '
        'category=$category subject=$subject '
        'photo=${photoBase64 == null ? "none" : "base64 (${photoBase64.length} chars)"} '
        'lat=$latitude lng=$longitude');

    final http.Response res;
    try {
      res = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(payload))
          .timeout(const Duration(seconds: 40));
    } catch (e) {
      debugPrint('🚨 [FEEDBACK] network error: $e');
      throw Exception(
          'Unable to reach the server. Please check your connection and try again.');
    }

    debugPrint('🟢 [FEEDBACK] status=${res.statusCode} body=${res.body}');

    Map<String, dynamic>? body;
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    } catch (_) {}

    if (res.statusCode == 200 && body?['message'] == 'success') {
      return body?['data']?.toString() ?? 'Your query submitted successfully';
    }
    throw Exception(
        body?['data']?.toString() ?? 'Submission failed. Please try again.');
  }
}