import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// One support-chat message.
class ChatMessage {
  final int id;
  final String sender; // 'user' | 'admin'
  final String? name;
  final String message;
  final String createdAt;

  ChatMessage({
    required this.id,
    required this.sender,
    this.name,
    required this.message,
    required this.createdAt,
  });

  bool get isUser => sender == 'user';

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: (j['id'] as num?)?.toInt() ?? 0,
        sender: j['sender']?.toString() ?? 'user',
        name: j['name']?.toString(),
        message: j['message']?.toString() ?? '',
        createdAt: j['created_at']?.toString() ?? '',
      );
}

/// Support chat over REST. Uses the same `API_BASE` as the other web services
/// (direct backend by default, or the bundled proxy with `--dart-define`).
class ChatService {
  static const String _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://shanviaconsulting.com/api',
  );

  static Future<List<ChatMessage>> fetch(String phone, {int since = 0}) async {
    final uri = Uri.parse(
        '$_base/chat/list?phone=${Uri.encodeQueryComponent(phone)}&since=$since');
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Failed to load chat (${res.statusCode})');
    }
    final decoded = jsonDecode(res.body);
    final data = (decoded is Map && decoded['data'] is List)
        ? decoded['data'] as List
        : const [];
    return data.whereType<Map<String, dynamic>>().map(ChatMessage.fromJson).toList();
  }

  static Future<void> send(String phone, String message, {String? name}) async {
    final uri = Uri.parse('$_base/chat/send');
    final res = await http
        .post(uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'phone': phone,
              'message': message,
              if (name != null && name.isNotEmpty) 'name': name,
            }))
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      debugPrint('🚨 [CHAT] send failed: ${res.statusCode} ${res.body}');
      throw Exception('Failed to send (${res.statusCode})');
    }
  }
}