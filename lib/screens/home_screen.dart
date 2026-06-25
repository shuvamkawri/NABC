import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _carouselIndex = 0;
  int _newsIndex = 0;
  late Timer _newsTimer;

  static const String _base = 'https://nabcapp.com/images';

  final List<Map<String, String>> sliderBanners = [
    {'image': '$_base/slider/1.jpg', 'title': '46th NABC 2026', 'subtitle': 'July 3–5 | Westchester County Center, NY', 'tag': 'GRAND CELEBRATION'},
    {'image': '$_base/slider/2.jpg', 'title': 'Bollywood Dhamaka', 'subtitle': 'Vishal-Shekhar | Sunday July 5, 7:00 PM', 'tag': 'FEATURED SHOW'},
    {'image': '$_base/slider/3.jpg', 'title': 'Saturday Night Spectacular', 'subtitle': 'Shantanu Moitra & Kaushiki Chakraborty', 'tag': 'MUST WATCH'},
    {'image': '$_base/Vishal-Shekhar.png', 'title': 'Amjad Ali Khan', 'subtitle': 'Sarod Maestro | Live Performance', 'tag': 'CELEBRITY ARTIST'},
  ];

  final List<String> hotNews = [
    '🔴 No single-day registration available for NABC 2026',
    '🏨 Special accommodation offer for standard registrants — Book now!',
    '🚌 Shuttle buses every 15–20 min during peak hours',
    '🍽️ Food coupon registration now open — Limited slots!',
    '🎭 NABC Idol talent competition open for ages up to 23',
  ];

  @override
  void initState() {
    super.initState();
    _newsTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) setState(() => _newsIndex = (_newsIndex + 1) % hotNews.length);
    });
  }

  @override
  void dispose() {
    _newsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: CustomAppBar(
        title: 'NABC 2026',
        subtitle: '3–5 July | Westchester County Center, NY',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(context),
            _buildNewsTicker(context),
            _buildQuickActions(context),
            _buildScheduleTimeline(context),
            _buildPerformersSection(context),
            _buildAccommodationPreview(context),
            _buildSponsorsSection(context),
            _buildRegistrationCTA(context),
            SizedBox(height: context.pagePad * 1.5),
          ],
        ),
      ),
    );
  }

  // ─── HERO BANNER ─────────────────────────────────────────────
  Widget _buildHeroBanner(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: context.bannerH,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            viewportFraction: 1.0,
            onPageChanged: (i, _) => setState(() => _carouselIndex = i),
          ),
          items: sliderBanners.map((b) => _buildSlide(context, b)).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(sliderBanners.length, (i) {
            final active = _carouselIndex == i;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: active ? 20 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: active ? AppColors.primaryBlue : context.borderColor,
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildSlide(BuildContext context, Map<String, String> banner) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          banner['image']!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.darkBlue,
            child: const Icon(Icons.celebration, size: 60, color: Colors.white24),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xCC000000), Color(0x33000000)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(context.pagePad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white38),
                ),
                child: Text(
                  banner['tag']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.sp(10),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                banner['title']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.sp(22),
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                banner['subtitle']!,
                style: TextStyle(color: Colors.white70, fontSize: context.sp(12)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  // ─── NEWS TICKER ─────────────────────────────────────────────
  Widget _buildNewsTicker(BuildContext context) {
    return Container(
      color: context.isDark ? const Color(0xFF1A1200) : const Color(0xFFFFF3E0),
      padding: EdgeInsets.symmetric(horizontal: context.pagePad, vertical: 9),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.accentRed,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('LIVE',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: context.sp(10),
                    letterSpacing: 1)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween(begin: const Offset(0, 0.3), end: Offset.zero)
                      .animate(anim),
                  child: child,
                ),
              ),
              child: Text(
                hotNews[_newsIndex],
                key: ValueKey(_newsIndex),
                style: TextStyle(
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w500,
                  color: context.isDark ? const Color(0xFFFFCC80) : const Color(0xFF5D4037),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── QUICK ACTIONS ────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'Register', 'icon': Icons.app_registration_rounded, 'color': AppColors.primaryBlue, 'route': '/registration'},
      {'label': 'Book Hotel', 'icon': Icons.hotel_rounded, 'color': const Color(0xFF6A1B9A), 'route': '/accommodation'},
      {'label': 'Events', 'icon': Icons.event_rounded, 'color': const Color(0xFF00695C), 'route': '/events'},
      {'label': 'Performers', 'icon': Icons.star_rounded, 'color': AppColors.accentRed, 'route': '/performers'},
      {'label': 'Sponsors', 'icon': Icons.handshake_rounded, 'color': const Color(0xFFE65100), 'route': '/sponsors'},
      {'label': 'About', 'icon': Icons.info_rounded, 'color': const Color(0xFF37474F), 'route': '/about'},
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(context.pagePad, context.pagePad * 1.2, context.pagePad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(context, 'Quick Access'),
          SizedBox(height: context.pagePad * 0.8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: context.gridCount3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: context.isSmall ? 1.1 : 1.05,
            children: actions.map((a) {
              final color = a['color'] as Color;
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, a['route'] as String),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(context.cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: context.isDark ? 0.2 : 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(a['icon'] as IconData, color: Colors.white, size: context.iconLg),
                      SizedBox(height: context.isSmall ? 5 : 7),
                      Text(
                        a['label'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: context.sp(11),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── SCHEDULE TIMELINE ────────────────────────────────────────
  Widget _buildScheduleTimeline(BuildContext context) {
    final schedule = [
      {'day': 'Thu', 'date': 'Jul 3', 'event': 'Inaugural Program', 'time': '6:00 PM', 'color': AppColors.primaryBlue},
      {'day': 'Fri', 'date': 'Jul 4', 'event': 'Saturday Night Spectacular', 'time': '8:00 PM', 'color': const Color(0xFF6A1B9A)},
      {'day': 'Sat', 'date': 'Jul 5', 'event': 'Bollywood Dhamaka', 'time': '7:00 PM', 'color': AppColors.accentRed},
      {'day': 'Sun', 'date': 'Jul 5', 'event': 'Closing Ceremony', 'time': '5:00 PM', 'color': const Color(0xFF1B5E20)},
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(context.pagePad, context.pagePad * 1.2, context.pagePad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(context, 'Event Schedule'),
          SizedBox(height: context.pagePad * 0.8),
          SizedBox(
            height: context.isSmall ? 95 : 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: schedule.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final item = schedule[i];
                final baseColor = item['color'] as Color;
                // brighten dark colours in dark mode so they're visible on dark cards
                final color = context.isDark
                    ? Color.lerp(baseColor, Colors.white, 0.45)!
                    : baseColor;
                return Container(
                  width: context.wp(32).clamp(120, 150),
                  padding: EdgeInsets.all(context.cardPad),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(context.cardRadius),
                    border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
                    boxShadow: context.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: context.isDark ? 0.22 : 0.12),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '${item['day']} • ${item['date']}',
                          style: TextStyle(color: color, fontSize: context.sp(10), fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        item['event'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.sp(11),
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 11, color: color),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              item['time'] as String,
                              style: TextStyle(
                                  fontSize: context.sp(10), color: color, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── PERFORMERS ───────────────────────────────────────────────
  Widget _buildPerformersSection(BuildContext context) {
    final performers = [
      {'name': 'Amjad Ali Khan', 'role': 'Sarod Maestro', 'image': '$_base/overseas-performers/Amjad.png'},
      {'name': 'Vishal-Shekhar', 'role': 'Bollywood', 'image': '$_base/Vishal-Shekhar.png'},
      {'name': 'Kaushiki Chakraborty', 'role': 'Classical Vocalist', 'image': '$_base/Kaushiki.png'},
      {'name': 'Shantanu Moitra', 'role': 'Composer', 'image': '$_base/Shantanu-Moitra.png'},
      {'name': 'Taslima Nasrin', 'role': 'Author', 'image': '$_base/overseas-performers/Taslima-Nasrin.png'},
      {'name': 'Tanmoy Bose', 'role': 'Percussionist', 'image': '$_base/overseas-performers/Tanmoy-b.png'},
    ];

    final avatarSize = context.wp(16).clamp(62.0, 80.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(context.pagePad, context.pagePad * 1.2, context.pagePad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _sectionHeader(context, 'Celebrity Performers')),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/performers'),
                child: Text('See All', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: context.sp(13), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          SizedBox(height: context.pagePad * 0.6),
          SizedBox(
            height: avatarSize + 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: performers.length,
              separatorBuilder: (_, __) => SizedBox(width: context.isSmall ? 10 : 14),
              itemBuilder: (_, i) {
                final p = performers[i];
                final cs = Theme.of(context).colorScheme;
                return SizedBox(
                  width: avatarSize + 6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.primary.withValues(alpha: 0.4), width: 2),
                          boxShadow: context.cardShadow,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            p['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: cs.primary,
                              child: Center(child: Text(p['name']![0],
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p['name']!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w700, color: context.textPrimary, height: 1.3),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p['role']!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: context.sp(9), color: context.textSecondary),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── ACCOMMODATION PREVIEW ────────────────────────────────────
  Widget _buildAccommodationPreview(BuildContext context) {
    final hotels = [
      {'name': 'The OPUS White Plains', 'distance': '0.9 miles', 'price': '\$259/night', 'badge': 'CLOSEST',
        'color': const Color(0xFF1565C0), 'image': '$_base/accommodations/The-OPUS-White-Plains.jpeg'},
      {'name': 'Hampton Inn White Plains', 'distance': '3.7 miles', 'price': '\$199/night', 'badge': 'POPULAR',
        'color': const Color(0xFF00695C), 'image': '$_base/accommodations/Hampton-Inn-White-Plains.webp'},
      {'name': 'Sheraton Tarrytown', 'distance': '4.9 miles', 'price': '\$179/night', 'badge': 'VALUE',
        'color': const Color(0xFF6A1B9A), 'image': '$_base/accommodations/Sheraton-at-Tarrytow.jpeg'},
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(context.pagePad, context.pagePad * 1.2, context.pagePad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _sectionHeader(context, 'Hotels & Accommodation')),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/accommodation'),
                child: Text('View All', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: context.sp(13), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          SizedBox(height: context.pagePad * 0.6),
          ...hotels.map((h) {
            final color = h['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(context.cardPad),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(context.cardRadius),
                boxShadow: context.cardShadow,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      h['image'] as String,
                      width: context.wp(16).clamp(56.0, 70.0),
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 52,
                        color: color.withValues(alpha: 0.15),
                        child: Icon(Icons.hotel_rounded, color: color, size: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h['name'] as String,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: context.sp(12), color: context.textPrimary),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.directions_walk_rounded, size: 11, color: context.textSecondary),
                            const SizedBox(width: 3),
                            Text(h['distance'] as String,
                                style: TextStyle(fontSize: context.sp(10), color: context.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(h['badge'] as String,
                            style: TextStyle(color: color, fontSize: context.sp(8), fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(height: 3),
                      Text(h['price'] as String,
                          style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: context.sp(12))),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── SPONSORS ─────────────────────────────────────────────────
  Widget _buildSponsorsSection(BuildContext context) {
    final sponsors = [
      {'name': 'P.C. Chandra\nJewellers', 'image': '$_base/exhibitors_list/pcc-logo.jpg'},
      {'name': 'Bengal\nJewellery', 'image': '$_base/exhibitors_list/bengal-jewellery-logo.jpg'},
      {'name': 'Srijan\nResidency', 'image': '$_base/exhibitors_list/srijan.jpg'},
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(context.pagePad, context.pagePad * 1.2, context.pagePad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(context, 'Gold Sponsors'),
          SizedBox(height: context.pagePad * 0.8),
          Row(
            children: sponsors.asMap().entries.map((e) {
              final i = e.key; final s = e.value;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < sponsors.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(context.cardRadius),
                    border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.3), width: 1.5),
                    boxShadow: context.cardShadow,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(s['image']!, height: 38, fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(Icons.workspace_premium_rounded,
                                color: AppColors.accentGold, size: 30)),
                      ),
                      const SizedBox(height: 5),
                      Text(s['name']!, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: context.sp(9), fontWeight: FontWeight.w700, color: context.textPrimary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── REGISTRATION CTA ─────────────────────────────────────────
  Widget _buildRegistrationCTA(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.pagePad, context.pagePad * 1.2, context.pagePad, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.pagePad * 1.4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(context.cardRadius + 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: context.isDark ? 0.2 : 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Text('Early Bird Discount!',
                style: TextStyle(color: Colors.white, fontSize: context.sp(20), fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text('Limited spots available. Register now for special rates!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: context.sp(12))),
            SizedBox(height: context.pagePad),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/registration'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: Text('Register Now',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: context.sp(13))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/accommodation'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Book Hotel',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: context.sp(13))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────
  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: context.sp(16),
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
