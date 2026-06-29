import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../widgets/banner_slider.dart';
import '../utils/image_url.dart';

/// Web edition: fetches the admin-managed sponsor advertisements from
/// `GET /api/all-advertisement`. Each row has `sponsorship_name`, `subtitle`,
/// `color` and an `image` (full S3 URL; legacy rows may be relative); this
/// service maps them onto [BannerSlide] and resolves the image via
/// [resolveImageUrl] so `Image.network` can load it.
class AdvertisementService {
  static const String _apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://shanviaconsulting.com/api',
  );

  static String get _origin =>
      _apiBase.startsWith('http') ? Uri.parse(_apiBase).origin : '';

  static Future<List<BannerSlide>> fetch() async {
    final uri = Uri.parse('$_origin/api/all-advertisement');
    debugPrint('🌐 [ADS] GET $uri');
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    // The endpoint returns 400 with an empty list when there are no ads.
    if (res.statusCode != 200) {
      debugPrint('ℹ️ [ADS] no advertisements (${res.statusCode})');
      return const [];
    }
    final decoded = jsonDecode(res.body);
    final data = (decoded is Map && decoded['data'] is List)
        ? decoded['data'] as List
        : const [];
    final slides = data.whereType<Map<String, dynamic>>().where((b) {
      final active = b['is_active'];
      return active == null || active == true || active == 1;
    }).map((b) {
      return BannerSlide(
        cat: 'SPONSOR',
        title: b['sponsorship_name']?.toString() ?? '',
        sub: b['subtitle']?.toString() ?? '',
        color: parseHexColor(b['color']?.toString()),
        img: resolveImageUrl(b['image']?.toString()),
      );
    }).toList();
    debugPrint('✅ [ADS] loaded ${slides.length} advertisement(s)');
    return slides;
  }
}