import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support & SOS')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSOSButton(context),
            const SizedBox(height: 24),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: context.sp(15),
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
              icon: Icons.phone,
              color: AppColors.successGreen,
              title: 'Call Event Helpdesk',
              subtitle: '+1 (914) 555-NABC',
              onTap: () =>
                  _showAction(context, 'Calling +1 (914) 555-NABC...'),
            ),
            const SizedBox(height: 10),
            _buildContactCard(
              context,
              icon: Icons.email_outlined,
              color: AppColors.primaryBlue,
              title: 'Email Support',
              subtitle: 'support@nabc2026.org',
              onTap: () => _showAction(
                  context, 'Opening email to support@nabc2026.org'),
            ),
            const SizedBox(height: 10),
            _buildContactCard(
              context,
              icon: Icons.language_outlined,
              color: const Color(0xFF6A1B9A),
              title: 'Visit Website',
              subtitle: 'www.nabcapp.com',
              onTap: () =>
                  _showAction(context, 'Opening NABC website...'),
            ),
            const SizedBox(height: 10),
            // _buildContactCard(
            //   context,
            //   icon: Icons.chat_bubble_outline,
            //   color: const Color(0xFF00695C),
            //   title: 'Live Chat',
            //   subtitle: 'Chat with a support agent now',
            //   onTap: () => _showAction(context, 'Opening live chat...'),
            // ),
            const SizedBox(height: 24),
            Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: context.sp(15),
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildEmergencyCard(
              context,
              '911 — Emergency Services',
              'Police, Fire, Ambulance',
              Icons.emergency_outlined,
              AppColors.accentRed,
              '911',
            ),
            const SizedBox(height: 10),
            _buildEmergencyCard(
              context,
              'Venue Security',
              'Westchester County Center',
              Icons.security_outlined,
              const Color(0xFFE65100),
              '+1 (914) 995-4050',
            ),
            const SizedBox(height: 10),
            _buildEmergencyCard(
              context,
              'Medical Station',
              'First Aid — Hall Entrance',
              Icons.local_hospital_outlined,
              AppColors.successGreen,
              '+1 (914) 555-MED1',
            ),
            const SizedBox(height: 24),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: context.sp(15),
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildFAQs(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSButton(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showSOSConfirm(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFC62828), Color(0xFFEF5350)]),
          borderRadius: BorderRadius.circular(context.cardRadius + 2),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white38, width: 2),
              ),
              child: const Icon(Icons.sos, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 10),
            Text(
              'SOS Emergency',
              style: TextStyle(
                color: Colors.white,
                fontSize: context.sp(19),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hold 2 seconds to send emergency alert',
              style: TextStyle(
                color: Colors.white70,
                fontSize: context.sp(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.cardPad),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(context.cardRadius),
          boxShadow: context.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: context.sp(13),
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: context.sp(12),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context, String title,
      String subtitle, IconData icon, Color color, String number) {
    return GestureDetector(
      onTap: () => _showAction(context, 'Calling $number...'),
      child: Container(
        padding: EdgeInsets.all(context.cardPad),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(context.cardRadius),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: context.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: context.sp(13),
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: context.sp(11),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'Call',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFAQs(BuildContext context) {
    final faqs = [
      ('How do I pick up my badge?', 'Badges can be collected at the Registration Desk near Main Entrance.'),
      ('Is there parking available?', 'Yes, parking is available at the Westchester County Center garage. Shuttle service is also available from partner hotels.'),
      ('Can I change my meal preference?', 'Meal changes can be requested at the Food Coupon desk up to 24 hours before the session.'),
      ('How do I access event updates?', 'Real-time updates are available via the Messages section of this app.'),
    ];

    return faqs.map((f) => ExpansionTile(
          title: Text(
            f.$1,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.sp(13),
              color: context.textPrimary,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          children: [
            Text(
              f.$2,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: context.sp(12),
                height: 1.5,
              ),
            ),
          ],
        )).toList();
  }

  void _showAction(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSOSConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.sos, color: AppColors.accentRed),
            SizedBox(width: 8),
            Text('Send SOS Alert?',
                style: TextStyle(color: AppColors.accentRed)),
          ],
        ),
        content: const Text(
          'This will notify NABC security and event coordinators of your location immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('SOS alert sent! Help is on the way.'),
                  backgroundColor: AppColors.accentRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                foregroundColor: Colors.white),
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );
  }
}