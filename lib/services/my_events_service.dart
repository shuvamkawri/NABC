import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Web edition — persists "My Events" to the backend, using the same `API_BASE`
/// as the other web services.
class MyEventsService {
  static const String _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://shanviaconsulting.com/api',
  );

  static Future<List<String>> fetchIds(String reg) async {
    final uri = Uri.parse(
        '$_base/my-events/ids?registration_number=${Uri.encodeQueryComponent(reg)}');
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Failed to load My Events (${res.statusCode})');
    }
    final decoded = jsonDecode(res.body);
    final list = (decoded is Map && decoded['data'] is List)
        ? decoded['data'] as List
        : const [];
    return list.map((e) => e.toString()).toList();
  }

  static Future<void> add(String reg, String eventId) async {
    final res = await http
        .post(Uri.parse('$_base/my-events/add'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'registration_number': reg, 'event_id': eventId}))
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      debugPrint('🚨 [MYEVENTS] add failed: ${res.statusCode} ${res.body}');
      throw Exception('Failed to add (${res.statusCode})');
    }
  }

  static Future<void> remove(String reg, String eventId) async {
    final res = await http
        .post(Uri.parse('$_base/my-events/remove'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'registration_number': reg, 'event_id': eventId}))
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      debugPrint('🚨 [MYEVENTS] remove failed: ${res.statusCode} ${res.body}');
      throw Exception('Failed to remove (${res.statusCode})');
    }
  }
}
