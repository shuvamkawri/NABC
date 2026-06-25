import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'utils/theme_controller.dart';
import 'utils/session.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_app_screen.dart';
import 'screens/home_screen.dart';
import 'screens/events_screen.dart';
import 'screens/accommodation_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/performers_screen.dart';
import 'screens/sponsors_screen.dart';
import 'screens/about_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/event_calendar_screen.dart';
import 'screens/my_events_screen.dart';
import 'screens/my_registration_screen.dart';
import 'screens/my_accommodation_screen.dart';
import 'screens/my_food_screen.dart';
import 'screens/promotional_videos_screen.dart';
import 'screens/programs_screen.dart';
import 'screens/my_volunteer_screen.dart';
import 'screens/my_transportation_screen.dart';
import 'screens/find_friend_screen.dart';
import 'screens/support_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.init();
  await Session.init();
  runApp(const NABCApp());
}

class NABCApp extends StatelessWidget {
  const NABCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) => MaterialApp(
      title: 'NABC 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // darkTheme: AppTheme.dark(), // dark mode disabled for now
      themeMode: ThemeMode.light,
      builder: (context, child) => MobileFrame(child: child!),
      home: const SplashScreen(),
      routes: {
        '/splash': (ctx) => const SplashScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/main': (ctx) => const MainAppScreen(),
        '/home': (ctx) => const HomeScreen(),
        '/events': (ctx) => const EventsScreen(),
        '/accommodation': (ctx) => const AccommodationScreen(),
        '/registration': (ctx) => const RegistrationScreen(),
        '/performers': (ctx) => const PerformersScreen(),
        '/sponsors': (ctx) => const SponsorsScreen(),
        '/about': (ctx) => const AboutScreen(),
        '/dashboard': (ctx) => const DashboardScreen(),
        '/calendar': (ctx) => const EventCalendarScreen(),
        '/my-events': (ctx) => const MyEventsScreen(standalone: true),
        '/my-registration': (ctx) => const MyRegistrationScreen(),
        '/my-accommodation': (ctx) => const MyAccommodationScreen(),
        '/my-food': (ctx) => const MyFoodScreen(),
        '/promo-videos': (ctx) => const PromotionalVideosScreen(),
        '/programs': (ctx) => const ProgramsScreen(),
        '/my-volunteer': (ctx) => const MyVolunteerScreen(),
        '/my-transportation': (ctx) => const MyTransportationScreen(),
        '/find-friend': (ctx) => const FindFriendScreen(),
        '/support': (ctx) => const SupportScreen(),
        '/messages': (ctx) => const MessagesScreen(),
        '/feedback': (ctx) => const FeedbackScreen(),
        '/notifications': (ctx) => const NotificationsScreen(),
        '/profile': (ctx) => const ProfileScreen(),
      },
    ),
    );
  }
}

/// Forces a phone-style layout everywhere.
///
/// On real phones (and any viewport ≤ [_maxWidth]) the app fills the screen
/// exactly as before. On wider viewports (desktop browsers, tablets) the app
/// is rendered inside a centered mobile-width column on a dark backdrop, and
/// the inner [MediaQuery] is narrowed to that width so every responsive
/// helper (`context.sw`, `context.sp`, grids, paddings) computes a correct
/// mobile layout instead of a stretched desktop one.
class MobileFrame extends StatelessWidget {
  const MobileFrame({super.key, required this.child});

  final Widget child;
  static const double _maxWidth = 480;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // Real phone (or narrow window): keep native full-bleed behaviour.
    if (mq.size.width <= _maxWidth) return child;

    // Wide window: letterbox a mobile-width frame and tell the subtree it is
    // only [_maxWidth] wide so all percentage/scaled sizing stays mobile.
    return ColoredBox(
      color: const Color(0xFF0A1326),
      child: Center(
        child: ClipRect(
          child: SizedBox(
            width: _maxWidth,
            height: mq.size.height,
            child: MediaQuery(
              data: mq.copyWith(size: Size(_maxWidth, mq.size.height)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}