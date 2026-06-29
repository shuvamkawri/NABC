import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../widgets/banner_slider.dart';
import '../utils/image_url.dart';

/// Web edition: fetches admin-managed slider banners. Uses the same `API_BASE`
/// as the other web services; image URLs (full S3 URLs, or legacy relative
/// paths) are resolved via [resolveImageUrl].
class BannersService {
  static const String _apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://shanviaconsulting.com/api',
  );

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
        img: resolveImageUrl(b['img']?.toString()),
      );
    }).toList();
  }
}
