import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../services/banners_service.dart';

/// Parses a "#RRGGBB" (or "RRGGBB") hex string into a [Color].
/// Falls back to NABC blue when missing/invalid.
Color parseHexColor(String? hex) {
  if (hex == null || hex.isEmpty) return const Color(0xFF1565C0);
  var h = hex.replaceAll('#', '').trim();
  if (h.length == 6) h = 'FF$h';
  final v = int.tryParse(h, radix: 16);
  return v == null ? const Color(0xFF1565C0) : Color(v);
}

class BannerSlide {
  final String cat;
  final String title;
  final String sub;
  final Color color;
  final String img;
  const BannerSlide({
    required this.cat,
    required this.title,
    required this.sub,
    required this.color,
    required this.img,
  });
}

// Shared NABC slides used across screens
const nabcBannerSlides = [
  BannerSlide(cat: 'COMING EVENTS', title: 'Inaugural Program', sub: 'July 3 • 6:00 PM • Main Stage', color: Color(0xFF1565C0), img: 'https://nabcapp.com/images/slider/1.jpg'),
  BannerSlide(cat: 'COMING EVENTS', title: 'Saturday Night Spectacular', sub: 'Shantanu Moitra & Kaushiki • July 4', color: Color(0xFF6A1B9A), img: 'https://nabcapp.com/images/slider/3.jpg'),
  BannerSlide(cat: 'COMING EVENTS', title: 'Sunday Bollywood Dhamaka', sub: 'Vishal-Shekhar • July 5 • 7:00 PM', color: Color(0xFFD32F2F), img: 'https://nabcapp.com/images/slider/2.jpg'),
  BannerSlide(cat: 'CELEBRITIES', title: 'Amjad Ali Khan', sub: 'Sarod Maestro • Live Performance', color: Color(0xFF0D47A1), img: 'https://nabcapp.com/images/overseas-performers/Amjad.png'),
  BannerSlide(cat: 'CELEBRITIES', title: 'Kaushiki Chakraborty', sub: 'Hindustani Classical Vocalist', color: Color(0xFF4A148C), img: 'https://nabcapp.com/images/Kaushiki.png'),
  BannerSlide(cat: 'CELEBRITIES', title: 'Vishal-Shekhar', sub: 'Bollywood Music Duo', color: Color(0xFFB71C1C), img: 'https://nabcapp.com/images/Vishal-Shekhar.png'),
  BannerSlide(cat: 'PARTNERING ORGS', title: 'P.C. Chandra Jewellers', sub: 'Gold Sponsor • NABC 2026', color: Color(0xFFE65100), img: 'https://nabcapp.com/images/exhibitors_list/pcc-logo.jpg'),
  BannerSlide(cat: 'PARTNERING ORGS', title: 'Bengal Jewellery', sub: 'Gold Sponsor • NABC 2026', color: Color(0xFF1B5E20), img: 'https://nabcapp.com/images/exhibitors_list/bengal-jewellery-logo.jpg'),
  BannerSlide(cat: 'PARTNERING ORGS', title: 'Srijan Residency', sub: 'Official Hotel Partner', color: Color(0xFF006064), img: 'https://nabcapp.com/images/exhibitors_list/srijan.jpg'),
];

class BannerSlider extends StatefulWidget {
  /// Explicit slides. When null, the slider loads banners from the API
  /// (admin-managed) and falls back to [nabcBannerSlides] until they arrive.
  final List<BannerSlide>? slides;
  final String? excludeCategory; // drop slides with this category (e.g. partners)
  final double? height;
  final bool showTopBar;
  final VoidCallback? onSearch;
  final VoidCallback? onNotification;

  const BannerSlider({
    super.key,
    this.slides,
    this.excludeCategory,
    this.height,
    this.showTopBar = false,
    this.onSearch,
    this.onNotification,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late PageController _ctrl;
  Timer? _timer;
  int _index = 0;
  late List<BannerSlide> _slides;

  List<BannerSlide> _filter(List<BannerSlide> s) =>
      widget.excludeCategory == null
          ? s
          : s.where((x) => x.cat != widget.excludeCategory).toList();

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
    // Show passed/bundled slides immediately; refresh from the API when no
    // explicit slides were provided.
    _slides = _filter(widget.slides ?? nabcBannerSlides);
    if (widget.slides == null) _loadFromApi();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _slides.isEmpty) return;
      final next = (_index + 1) % _slides.length;
      if (_ctrl.hasClients) {
        _ctrl.animateToPage(next,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    });
  }

  Future<void> _loadFromApi() async {
    try {
      final api = await BannersService.fetch();
      if (!mounted || api.isEmpty) return;
      setState(() {
        _slides = _filter(api);
        _index = 0;
      });
    } catch (_) {
      // keep fallback slides on any error
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_slides.isEmpty) return const SizedBox.shrink();
    final h = widget.height ?? context.hp(25).clamp(160.0, 220.0);

    return SizedBox(
      height: h,
      child: Stack(
        children: [
          // Slides
          PageView.builder(
            controller: _ctrl,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => _buildSlide(context, _slides[i]),
          ),

          // Top bar overlay (optional)
          if (widget.showTopBar)
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.pagePad, vertical: 8),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NABC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.sp(22),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.5,
                              shadows: const [
                                Shadow(color: Colors.black38, blurRadius: 6)
                              ],
                            )),
                        Text('46th Convention 2026',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: context.sp(9),
                              letterSpacing: 0.5,
                            )),
                      ],
                    ),
                    const Spacer(),
                    if (widget.onSearch != null)
                      _glassBtn(context, Icons.search_rounded,
                          widget.onSearch!),
                    if (widget.onNotification != null) ...[
                      const SizedBox(width: 8),
                      _glassBtn(context, Icons.notifications_outlined,
                          widget.onNotification!),
                    ],
                  ],
                ),
              ),
            ),

          // Dot indicators
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => GestureDetector(
                  onTap: () => _ctrl.animateToPage(i,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          i == _index ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassBtn(
      BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white30),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildSlide(BuildContext context, BannerSlide slide) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.network(
          slide.img,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  slide.color,
                  Color.lerp(slide.color, Colors.black, 0.4)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        // Vignette overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xF0000000),
                Color(0x66000000),
                Color(0x10000000),
              ],
              stops: [0.0, 0.55, 1.0],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        // Top dark scrim (if top bar shown)
        if (widget.showTopBar)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xCC000000), Color(0x00000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.4],
              ),
            ),
          ),

        // Slide content
        Positioned(
          left: 0,
          right: 0,
          bottom: 26,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.pagePad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: slide.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    slide.cat,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.sp(8),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  slide.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.sp(19),
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 8),
                      Shadow(color: Colors.black26, blurRadius: 16),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.schedule_rounded,
                      color: Colors.white60, size: 12),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      slide.sub,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: context.sp(11),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}