import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';

const _kSponsors = [
  _Sponsor('P. C. Chandra Jewellers', 'Gold'),
  _Sponsor('Bengal Jewellery', 'Gold'),
  _Sponsor('Srijan Residency Limited', 'Gold'),
  _Sponsor('NABC 2026 Official Partner', 'Silver'),
  _Sponsor('Atlantic City Marriott', 'Bronze'),
];

class _Sponsor {
  final String name;
  final String level;
  const _Sponsor(this.name, this.level);
}

class SponsorsBanner extends StatefulWidget {
  const SponsorsBanner({super.key});

  @override
  State<SponsorsBanner> createState() => _SponsorsBannerState();
}

class _SponsorsBannerState extends State<SponsorsBanner>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _animCtrl.addListener(_onAnimate);
  }

  void _onAnimate() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    if (pos.maxScrollExtent <= 0) return;
    // loopPoint = width of one copy of the list
    final loopPoint = (pos.maxScrollExtent + pos.viewportDimension) / 2;
    _scrollCtrl.jumpTo(_animCtrl.value * loopPoint);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5A0000), Color(0xFFB22222)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gold "VENDORS" label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: AppColors.accentGradient),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: Colors.white, size: 11),
                const SizedBox(width: 3),
                Text(
                  'VENDORS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.sp(8),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // Scrolling marquee — ListView handles layout correctly (no overflow)
          Expanded(
            child: ListView(
              controller: _scrollCtrl,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                ..._kSponsors.map((s) => _SponsorChip(sponsor: s)),
                ..._kSponsors.map((s) => _SponsorChip(sponsor: s)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SponsorChip extends StatelessWidget {
  final _Sponsor sponsor;
  const _SponsorChip({required this.sponsor});

  Color get _levelColor => switch (sponsor.level) {
        'Gold' => AppColors.accentGold,
        'Silver' => const Color(0xFFB0BEC5),
        _ => const Color(0xFFBF8A52),
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration:
                BoxDecoration(color: _levelColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            sponsor.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.sp(12.5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: _levelColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                  color: _levelColor.withValues(alpha: 0.45), width: 0.5),
            ),
            child: Text(
              sponsor.level,
              style: TextStyle(
                color: _levelColor,
                fontSize: context.sp(7.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
              width: 1,
              height: 14,
              color: Colors.white.withValues(alpha: 0.15)),
        ],
      ),
    );
  }
}
