import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Notif> _notifications = [
    _Notif(type: 'event', icon: Icons.event, color: AppColors.primaryBlue, title: 'Inaugural Program starts in 1 hour', subtitle: 'Main Stage • July 3 at 6:00 PM', time: '1h ago', read: false),
    _Notif(type: 'food', icon: Icons.restaurant, color: const Color(0xFFE65100), title: 'Food coupon collection opens', subtitle: 'Collect your Dinner Gala coupon by 6:30 PM', time: '2h ago', read: false),
    _Notif(type: 'accommodation', icon: Icons.hotel, color: const Color(0xFF6A1B9A), title: 'Check-in reminder', subtitle: 'Hampton Inn check-in opens at 3:00 PM today', time: '3h ago', read: true),
    _Notif(type: 'volunteer', icon: Icons.volunteer_activism, color: const Color(0xFF2E7D32), title: 'Volunteer shift reminder', subtitle: 'Your Gate B shift starts at 4:00 PM', time: '4h ago', read: true),
    _Notif(type: 'transport', icon: Icons.directions_bus, color: const Color(0xFF0277BD), title: 'Shuttle update', subtitle: 'Next shuttle from Hampton Inn at 5:45 PM', time: '30m ago', read: false),
    _Notif(type: 'event', icon: Icons.event, color: AppColors.primaryBlue, title: 'NABC Idol voting is live!', subtitle: 'Vote for your favorite contestant now', time: '5h ago', read: true),
    _Notif(type: 'transport', icon: Icons.directions_bus, color: const Color(0xFF0277BD), title: 'Transportation confirmed', subtitle: 'Your shuttle booking for July 3 is confirmed', time: '1d ago', read: true),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n.read).length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications${unread > 0 ? ' ($unread)' : ''}'),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              for (final n in _notifications) {
                n.read = true;
              }
            }),
            child: const Text('Clear All',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(context.pagePad),
        itemCount: _notifications.length,
        itemBuilder: (_, i) {
          final n = _notifications[i];
          return GestureDetector(
            onTap: () => setState(() => n.read = true),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(context.cardPad),
              decoration: BoxDecoration(
                color: n.read
                    ? context.cardBg
                    : n.color.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(context.cardRadius),
                border: n.read
                    ? null
                    : Border.all(color: n.color.withValues(alpha: 0.25)),
                boxShadow: context.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: n.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(n.icon, color: n.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n.title,
                          style: TextStyle(
                            fontWeight:
                                n.read ? FontWeight.w600 : FontWeight.w800,
                            fontSize: context.sp(13),
                            color: context.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          n.subtitle,
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: context.sp(12),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n.time,
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: context.sp(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!n.read)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: n.color, shape: BoxShape.circle),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Notif {
  final String type;
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  bool read;

  _Notif({
    required this.type,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.read,
  });
}