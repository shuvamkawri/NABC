import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/responsive.dart';
import '../constants/colors.dart';
import 'dashboard_screen.dart';
import 'event_calendar_screen.dart';
import 'messages_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  // 0 = Home, 1 = Events, 2 = Messages
  int _selectedIndex = 0;
  int _messageCount  = 3;

  static const _screens = <Widget>[
    DashboardScreen(),
    EventCalendarScreen(),
    MessagesScreen(),
  ];

  static const _navItems = [
    _NavItem(icon: Icons.home_outlined,        activeIcon: Icons.home_rounded,          label: 'Home'),
    _NavItem(icon: Icons.festival_outlined,    activeIcon: Icons.festival_rounded,      label: 'Events'),
    _NavItem(icon: Icons.message_outlined,     activeIcon: Icons.message_rounded,       label: 'Messages'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(context, isDark),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    final bgColor      = isDark ? const Color(0xFF161E2A) : Colors.white;
    final activeColor  = AppColors.primaryBlue;
    final inactiveColor= isDark ? const Color(0xFF5C6472) : const Color(0xFF9CA3AF);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: isDark
                ? const Color(0xFF252D3A)
                : const Color(0xFFE8EDF5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item    = _navItems[i];
              final active  = _selectedIndex == i;
              final badgeCount = i == 2 ? _messageCount : 0;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() {
                    _selectedIndex = i;
                    if (i == 2) _messageCount = 0;
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with optional badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: active
                                  ? activeColor.withValues(alpha: 0.10)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              active ? item.activeIcon : item.icon,
                              color: active ? activeColor : inactiveColor,
                              size: 24,
                            ),
                          ),
                          if (badgeCount > 0)
                            Positioned(
                              top: 0, right: -2,
                              child: Container(
                                width: 16, height: 16,
                                decoration: const BoxDecoration(
                                  color: AppColors.accentRed,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    badgeCount > 9 ? '9+' : '$badgeCount',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Label
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: GoogleFonts.inter(
                          fontSize: context.sp(10),
                          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? activeColor : inactiveColor,
                        ),
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
