import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../widgets/banner_slider.dart';

/// Web edition: fetches the admin-managed sponsor advertisements from
/// `GET /api/all-advertisement`. Each row has `sponsorship_name`, `subtitle`,
/// `color` and a relative `image` path (e.g. `/uploads/banners/x.jpg`); this
/// service maps them onto [BannerSlide] and turns the image path into an
/// absolute URL so `Image.network` can load it.
///
/// The advertisement endpoint lives under the backend `/api` prefix (not the
/// `/api-attendee` member prefix), so we derive the origin from `API_BASE` and
/// build the `/api/all-advertisement` path from it.
class AdvertisementService {
  static const String _apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://45.79.175.205:3000/api-attendee',
  );

  static String get _origin =>
      _apiBase.startsWith('http') ? Uri.parse(_apiBase).origin : '';

  static String _abs(String img) {
    if (img.isEmpty || img.startsWith('http')) return img;
    return '$_origin${img.startsWith('/') ? '' : '/'}$img';
  }

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
        img: _abs(b['image']?.toString() ?? ''),
      );
    }).toList();
    debugPrint('✅ [ADS] loaded ${slides.length} advertisement(s)');
    return slides;
  }
}