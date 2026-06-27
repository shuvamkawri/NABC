import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../services/advertisement_service.dart';
import 'banner_slider.dart';

/// Self-loading sponsor-advertisement carousel shown at the bottom of the
/// dashboard (below the service icons). Fetches the admin-managed ads from
/// `GET /api/all-advertisement`; renders nothing until/unless ads exist.
/// Each slide shows the sponsor image with the sponsorship name + sub-text,
/// auto-advancing every 4 seconds with tappable dot indicators.
class AdvertisementCarousel extends StatefulWidget {
  final double? height;
  const AdvertisementCarousel({super.key, this.height});

  @override
  State<AdvertisementCarousel> createState() => _AdvertisementCarouselState();
}

class _AdvertisementCarouselState extends State<AdvertisementCarousel> {
  final PageController _ctrl = PageController();
  Timer? _timer;
  int _index = 0;
  List<BannerSlide> _ads = const [];

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _ads.length < 2) return;
      final next = (_index + 1) % _ads.length;
      if (_ctrl.hasClients) {
        _ctrl.animateToPage(next,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    });
  }

  Future<void> _load() async {
    try {
      final ads = await AdvertisementService.fetch();
      if (!mounted || ads.isEmpty) return;
      setState(() => _ads = ads);
    } catch (_) {
      // No ads / network error → keep the section hidden.
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
    if (_ads.isEmpty) return const SizedBox.shrink();
    final isDark = context.isDark;
    final h = widget.height ?? context.hp(20).clamp(150.0, 190.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        _header(context, isDark),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: h,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _ctrl,
                  itemCount: _ads.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => _slide(context, _ads[i]),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _ads.length,
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
                            color: i == _index ? Colors.white : Colors.white38,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context, bool isDark) {
    return Row(children: [
      Container(
        width: 4,
        height: 22,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFCA28), Color(0xFFEF6C00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Our Sponsors',
              style: GoogleFonts.inter(
                fontSize: context.sp(17),
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
                letterSpacing: -0.4,
                height: 1.0,
              )),
          Text('Advertisement',
              style: GoogleFonts.inter(
                fontSize: context.sp(10),
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF4A90D9)
                    : AppColors.primaryBlue,
                letterSpacing: 0.4,
              )),
        ],
      ),
    ]);
  }

  Widget _slide(BuildContext context, BannerSlide ad) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          ad.img,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ad.color,
                  Color.lerp(ad.color, Colors.black, 0.4)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
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
        Positioned(
          left: 16,
          right: 16,
          bottom: 26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ad.color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SPONSORED',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: context.sp(8),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                ad.title,
                style: GoogleFonts.inter(
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
              if (ad.sub.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  ad.sub,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: context.sp(11),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}