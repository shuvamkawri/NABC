import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../widgets/banner_slider.dart';

/// Web edition: fetches admin-managed slider banners. Uses the same `API_BASE`
/// as the other web services and resolves the relative image path to an
/// absolute URL on the backend origin.
class BannersService {
  static const String _apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://45.79.175.205:3000/api-attendee',
  );

  static String _abs(String img) {
    if (img.isEmpty || img.startsWith('http')) return img;
    if (_apiBase.startsWith('http')) {
      final origin = Uri.parse(_apiBase).origin; // scheme://host:port
      return '$origin${img.startsWith('/') ? '' : '/'}$img';
    }
    return img; // relative API_BASE (proxy) → same-origin path
  }

  static Future<List<BannerSlide>> fetch() async {
    final uri = Uri.parse('$_apiBase/banners');
    debugPrint('🌐 [BANNERS] GET $uri');
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Failed to load banners (${res.statusCode})');
    }
    final decoded = jsonDecode(res.body);
    final data = (decoded is Map && decoded['data'] is List)
        ? decoded['data'] as List
        : const [];
    return data.whereType<Map<String, dynamic>>().map((b) {
      return BannerSlide(
        cat: b['cat']?.toString() ?? '',
        title: b['title']?.toString() ?? '',
        sub: b['sub']?.toString() ?? '',
        color: parseHexColor(b['color']?.toString()),
        img: _abs(b['img']?.toString() ?? ''),
      );
    }).toList();
  }
}
