import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../widgets/banner_slider.dart';
import '../widgets/advertisement_carousel.dart';
import '../widgets/install_button.dart';
import 'event_calendar_screen.dart';
import 'my_events_screen.dart';
import 'my_accommodation_screen.dart';
import 'my_food_screen.dart';
import 'messages_screen.dart';
import 'feedback_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';

// ─── Design tokens ─────────────────────────────────────────────────────
const _kDarkBg     = Color(0xFF07111E);
const _kDarkCard   = Color(0xFF0D1828);
const _kLightBg    = Color(0xFFEEF2F7);
const _kNavy       = Color(0xFF0A1F5C);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late List<Animation<double>> _tileAnims;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));

    _tileAnims = List.generate(7, (i) {
      final start = (0.32 + i * 0.07).clamp(0.0, 0.93);
      final end   = (start + 0.35).clamp(0.0, 1.0);
      return CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(start, end, curve: Curves.easeOutBack));
    });

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final items  = _buildItems(context);
    final heroH  = context.hp(27).clamp(175.0, 230.0);

    return Scaffold(
      backgroundColor: isDark ? _kDarkBg : _kLightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero SliverAppBar ────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: heroH,
            automaticallyImplyLeading: false,
            backgroundColor: _kNavy,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            actions: [
              const InstallButton(),
              _topBtn(context, Icons.info_outline_rounded,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()))),
              _topBtn(context, Icons.person_outline_rounded,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()))),
              const SizedBox(width: 4),
            ],
            title: _buildTitle(context),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _buildHero(context, heroH, isDark),
            ),
          ),

          // ── Scrollable body ──────────────────────────────────────
          SliverToBoxAdapter(
            child: _buildBody(context, items, isDark),
          ),
        ],
      ),
    );
  }

  // ── App-bar title ────────────────────────────────────────────────
  Widget _buildTitle(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFFCA28), Color(0xFFEF6C00)]),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text('NABC',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: context.sp(13),
              fontWeight: FontWeight.w900,
              letterSpacing: 2.2,
            )),
      ),
      const SizedBox(width: 8),
      Text('2026',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: context.sp(17),
            fontWeight: FontWeight.w800,
          )),
    ]);
  }

  // ── Hero background ──────────────────────────────────────────────
  Widget _buildHero(BuildContext context, double heroH, bool isDark) {
    final fadeColor = isDark ? _kDarkBg : _kLightBg;
    return Stack(fit: StackFit.expand, children: [
      BannerSlider(
        height: heroH,
        excludeCategory: 'PARTNERING ORGS',
      ),
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xBB000000), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.50],
          ),
        ),
      ),
      Positioned(
        bottom: 0, left: 0, right: 0,
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, fadeColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    ]);
  }

  // ── Body ─────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context, List<_DashItem> items, bool isDark) {
    final pad = context.pagePad;

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 10, pad, pad + 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          _buildSectionHeader(context),
          const SizedBox(height: 14),

          // 3 × 2 icon grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
            children: List.generate(6, (i) => AnimatedBuilder(
              animation: _tileAnims[i],
              builder: (_, child) => Opacity(
                opacity: _tileAnims[i].value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, 22 * (1 - _tileAnims[i].value.clamp(0.0, 1.0))),
                  child: child,
                ),
              ),
              child: _ServiceTile(item: items[i], isDark: isDark),
            )),
          ),

          const SizedBox(height: 12),

          // Messages — full-width tile
          AnimatedBuilder(
            animation: _tileAnims[6],
            builder: (_, child) => Opacity(
              opacity: _tileAnims[6].value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, 22 * (1 - _tileAnims[6].value.clamp(0.0, 1.0))),
                child: child,
              ),
            ),
            child: _WideMessagesTile(item: items[6], isDark: isDark),
          ),

          // Sponsor advertisement carousel (admin-managed, hidden when empty)
          const AdvertisementCarousel(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
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
          Text('Member Services',
              style: GoogleFonts.inter(
                fontSize: context.sp(17),
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
                letterSpacing: -0.4,
                height: 1.0,
              )),
          // Text('Member Services',
          //     style: GoogleFonts.inter(
          //       fontSize: context.sp(10),
          //       fontWeight: FontWeight.w600,
          //       color: context.isDark
          //           ? const Color(0xFF4A90D9)
          //           : AppColors.primaryBlue,
          //       letterSpacing: 0.4,
          //     )),
        ],
      ),
    ]);
  }

  Widget _topBtn(BuildContext context, IconData icon, VoidCallback onTap) =>
      IconButton(
        icon: Icon(icon, color: Colors.white.withValues(alpha: 0.88), size: 22),
        onPressed: onTap,
      );

  List<_DashItem> _buildItems(BuildContext context) => [
    _DashItem(
        label: 'My Profile',
        icon: Icons.person_rounded,
        imagePath: 'assets/icons/profile.png',
        accent: const Color(0xFFE040FB),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()))),
    _DashItem(
        label: 'Food',
        icon: Icons.restaurant_rounded,
        imagePath: 'assets/icons/food.png',
        accent: const Color(0xFF29B6F6),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const MyFoodScreen()))),
    _DashItem(
        label: 'Accommodation',
        icon: Icons.hotel_rounded,
        imagePath: 'assets/icons/accommodation.png',
        accent: const Color(0xFF76C442),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const MyAccommodationScreen()))),
    // _DashItem(
    //     label: 'Transport',
    //     icon: Icons.directions_bus_rounded,
    //     imagePath: 'assets/icons/transport.png',
    //     accent: const Color(0xFFFF5722),
    //     onTap: () => Navigator.push(context,
    //         MaterialPageRoute(builder: (_) => const MyTransportationScreen()))),
    _DashItem(
        label: 'Events',
        icon: Icons.celebration_rounded,
        imagePath: 'assets/icons/events.png',
        accent: const Color(0xFFFFCA28),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EventCalendarScreen()))),
    _DashItem(
        label: 'My Events',
        icon: Icons.event_available_rounded,
        imagePath: 'assets/icons/my_event.png',
        accent: const Color(0xFF00BFA5),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => const MyEventsScreen(standalone: true)))),
    _DashItem(
        label: 'Support',
        icon: Icons.headset_mic_rounded,
        imagePath: 'assets/icons/feedback.png',
        accent: const Color(0xFF9C27B0),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const FeedbackScreen()))),
    _DashItem(
        label: 'Messages',
        icon: Icons.chat_bubble_rounded,
        accent: const Color(0xFF2196F3),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const MessagesScreen()))),
  ];
}

// ─── Data model ─────────────────────────────────────────────────────────
class _DashItem {
  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  final int badge;
  final String? imagePath;
  const _DashItem({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
    this.badge = 0,
    this.imagePath,
  });
}

// ─── Service tile (3-column grid) ────────────────────────────────────────
class _ServiceTile extends StatefulWidget {
  final _DashItem item;
  final bool isDark;
  const _ServiceTile({required this.item, required this.isDark});
  @override
  State<_ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<_ServiceTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        lowerBound: 0.0, upperBound: 1.0);
    _scale = Tween<double>(begin: 1.0, end: 0.91)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final accent = widget.item.accent;
    final glowColor = isDark
        ? Color.lerp(accent, Colors.white, 0.10)!
        : accent;
    final iconSz = context.isSmall ? 60.0 : 66.0;

    return GestureDetector(
      onTapDown:   (_) => _press.forward(),
      onTapUp:     (_) { _press.reverse(); widget.item.onTap(); },
      onTapCancel: ()  => _press.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? _kDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? glowColor.withValues(alpha: 0.14)
                  : const Color(0xFFE4E9F2),
              width: 1.0,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.16),
                      blurRadius: 22,
                      offset: const Offset(0, 7),
                      spreadRadius: -5,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.38),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top accent line
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              Color.lerp(accent, Colors.white, 0.25)!,
                              accent,
                            ]
                          : [
                              Color.lerp(accent, Colors.white, 0.30)!,
                              accent,
                            ],
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        _buildIcon(iconSz, isDark, accent),

                        const SizedBox(height: 10),

                        // Label
                        Text(
                          widget.item.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: context.textPrimary,
                            fontSize: context.sp(11),
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(double iconSz, bool isDark, Color accent) {
    final img = widget.item.imagePath;

    if (img != null) {
      // Glossy PNG icon — show directly; add glow halo in dark mode
      if (isDark) {
        return Container(
          width: iconSz,
          height: iconSz,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.50),
                blurRadius: 26,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: accent.withValues(alpha: 0.22),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Image.asset(img, fit: BoxFit.contain),
        );
      }
      return SizedBox(
        width: iconSz,
        height: iconSz,
        child: Image.asset(img, fit: BoxFit.contain),
      );
    }

    // Fallback: gradient rounded-rect with Material icon
    final c0 = isDark
        ? Color.lerp(accent, Colors.white, 0.25)!
        : Color.lerp(accent, Colors.white, 0.20)!;
    return Container(
      width: iconSz,
      height: iconSz,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(iconSz * 0.28),
        gradient: LinearGradient(
          colors: [c0, accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.50 : 0.35),
            blurRadius: 18,
            offset: const Offset(0, 5),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Icon(widget.item.icon, color: Colors.white, size: iconSz * 0.50),
    );
  }
}

// ─── Messages wide tile ──────────────────────────────────────────────────
class _WideMessagesTile extends StatefulWidget {
  final _DashItem item;
  final bool isDark;
  const _WideMessagesTile({required this.item, required this.isDark});
  @override
  State<_WideMessagesTile> createState() => _WideMessagesTileState();
}

class _WideMessagesTileState extends State<_WideMessagesTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        lowerBound: 0.0, upperBound: 1.0);
    _scale = Tween<double>(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark  = widget.isDark;
    final accent  = widget.item.accent;
    final glowC   = isDark ? Color.lerp(accent, Colors.white, 0.12)! : accent;
    const iconSz  = 50.0;

    // Icon: gradient rounded-rect (Messages has no PNG)
    final iconC0 = isDark
        ? Color.lerp(accent, Colors.white, 0.28)!
        : Color.lerp(accent, Colors.white, 0.22)!;

    return GestureDetector(
      onTapDown:   (_) => _press.forward(),
      onTapUp:     (_) { _press.reverse(); widget.item.onTap(); },
      onTapCancel: ()  => _press.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: isDark ? _kDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? glowC.withValues(alpha: 0.14)
                  : const Color(0xFFE4E9F2),
              width: 1.0,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: glowC.withValues(alpha: 0.16),
                      blurRadius: 22,
                      offset: const Offset(0, 7),
                      spreadRadius: -5,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.38),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),

              // Gradient icon
              Container(
                width: iconSz,
                height: iconSz,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(iconSz * 0.28),
                  gradient: LinearGradient(
                    colors: [iconC0, accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowC.withValues(alpha: isDark ? 0.48 : 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                      spreadRadius: -3,
                    ),
                  ],
                ),
                child: const Icon(Icons.chat_bubble_rounded,
                    color: Colors.white, size: 24),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Messages',
                        style: GoogleFonts.inter(
                          color: context.textPrimary,
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        )),
                    const SizedBox(height: 2),
                    Text('View your conversations',
                        style: GoogleFonts.inter(
                          color: context.textSecondary,
                          fontSize: context.sp(10),
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),

              if (widget.item.badge > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${widget.item.badge} new',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: context.sp(10),
                        fontWeight: FontWeight.w800,
                      )),
                ),
                const SizedBox(width: 10),
              ],

              Icon(Icons.chevron_right_rounded,
                  color: context.textSecondary.withValues(alpha: 0.50),
                  size: 22),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}