import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

/// Web edition: fetches the admin-managed event list.
///
/// Uses the same `API_BASE` as [AttendeeService] so it works either directly
/// against the backend (`.../api/events`) or through the bundled Dart
/// proxy (`/api/events`). This is a plain GET (no body), so no proxy is strictly
/// required when the page is served over http and CORS is open.
class EventsService {
  static const String _apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://shanviaconsulting.com/api',
  );

  static Future<List<Event>> fetchEvents() async {
    final uri = Uri.parse('$_apiBase/events');
    debugPrint('🌐 [EVENTS] GET $uri');
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    debugPrint('🌐 [EVENTS] status: ${res.statusCode}');

    if (res.statusCode != 200) {
      throw Exception('Failed to load events (${res.statusCode})');
    }
    final decoded = jsonDecode(res.body);
    final data = (decoded is Map && decoded['data'] is List)
        ? decoded['data'] as List
        : const [];
    final events = data
        .whereType<Map<String, dynamic>>()
        .map(Event.fromJson)
        .where((e) => e.title.isNotEmpty)
        .toList();
    debugPrint('✅ [EVENTS] parsed ${events.length} event(s)');
    return events;
  }
}