import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../utils/session.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  int _currentBanner = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  static const String _base = 'https://nabcapp.com/images';

  final List<Map<String, String>> _banners = [
    {
      'image': '$_base/slider/1.jpg',
      'title': '46th NABC 2026',
      'subtitle': 'July 3–5 | Westchester County Center, NY',
      'tag': 'COMING EVENT',
    },
    {
      'image': '$_base/Vishal-Shekhar.png',
      'title': 'Vishal-Shekhar',
      'subtitle': 'Bollywood Night — Sunday July 5',
      'tag': 'CELEBRITY',
    },
    {
      'image': '$_base/Kaushiki.png',
      'title': 'Kaushiki Chakraborty',
      'subtitle': 'Saturday Night Spectacular',
      'tag': 'CELEBRITY',
    },
    {
      'image': '$_base/overseas-performers/Amjad.png',
      'title': 'Amjad Ali Khan',
      'subtitle': 'Sarod Maestro — Live Performance',
      'tag': 'CELEBRITY',
    },
    {
      'image': '$_base/exhibitors_list/pcc-logo.jpg',
      'title': 'P.C. Chandra Jewellers',
      'subtitle': 'Gold Sponsor — NABC 2026',
      'tag': 'PARTNERING ORGANIZATION',
    },
    {
      'image': '$_base/exhibitors_list/bengal-jewellery-logo.jpg',
      'title': 'Bengal Jewellery',
      'subtitle': 'Proud Partner of NABC 2026',
      'tag': 'PARTNERING ORGANIZATION',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => _destination(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  /// When a session is already restored, skip login and go straight to the
  /// dashboard; otherwise show the login screen.
  Widget _destination() =>
      Session.isLoggedIn ? const DashboardScreen() : const LoginScreen();

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = context.pagePad;
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: double.infinity,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                viewportFraction: 1.0,
                onPageChanged: (i, _) => setState(() => _currentBanner = i),
              ),
              items: _banners.map(_buildSlide).toList(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(pad, 40, pad, context.hp(6)),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xEE000000), Color(0x00000000)],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_banners.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentBanner == i ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentBanner == i
                                ? Colors.white
                                : Colors.white38,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: context.hp(2.5)),
                    Text(
                      'NABC 2026',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.sp(34),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: context.hp(0.8)),
                    Text(
                      'North America Bengali Conference',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: context.sp(13),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.hp(3)),
                    SizedBox(
                      width: context.wp(45).clamp(160.0, 220.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => _destination()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.symmetric(
                              vertical: context.isSmall ? 12 : 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: context.sp(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(Map<String, String> banner) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          banner['image']!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.darkBlue,
            child: const Center(
              child: Icon(Icons.celebration, size: 80, color: Colors.white24),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xAA000000), Color(0x44000000)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accentRed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              banner['tag']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}