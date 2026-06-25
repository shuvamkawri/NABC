import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/attendee_model.dart';
import '../utils/responsive.dart';
import '../utils/session.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Attendee? get _attendee => Session.current;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: context.isSmall ? 200 : 220,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: 'Sign Out',
                onPressed: () => _confirmLogout(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: context.isSmall ? 38 : 44,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            child: Icon(Icons.person,
                                color: Colors.white,
                                size: context.isSmall ? 38 : 44),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  color: AppColors.primaryBlue, size: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _attendee?.fullName.isNotEmpty == true
                            ? _attendee!.fullName
                            : 'NABC Member',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.sp(19),
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _attendee?.attendeeType.isNotEmpty == true
                            ? '${_attendee!.attendeeType} Registrant — NABC 2026'
                            : 'Registrant — NABC 2026',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: context.sp(12),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        body: _buildInfo(context),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final a = _attendee;
    if (a == null) {
      return Center(
        child: Text(
          'No profile information available.',
          style: TextStyle(color: context.textSecondary),
        ),
      );
    }

    String dash(String v) => v.trim().isEmpty ? '—' : v;
    final registeredOn = a.createdAt != null
        ? DateFormat('MMM d, yyyy').format(a.createdAt!.toLocal())
        : '—';

    final fields = <(String, String, IconData)>[
      ('Full Name', dash(a.fullName), Icons.person_outline),
      ('Email', dash(a.email), Icons.email_outlined),
      ('Phone', dash(a.phone), Icons.phone_outlined),
      ('Gender', dash(a.gender), Icons.wc_outlined),
      ('Attendee Type', dash(a.attendeeType), Icons.workspace_premium_outlined),
      ('Registration Number',
          dash(a.registrationNumber), Icons.confirmation_number_outlined),
      ('Address', dash(a.address), Icons.home_outlined),
      ('City', dash(a.city), Icons.location_city_outlined),
      ('State', dash(a.state), Icons.map_outlined),
      ('Zip Code', dash(a.zip), Icons.markunread_mailbox_outlined),
      ('Country', dash(a.country), Icons.public_outlined),
      if (a.spouseName != null)
        ('Spouse', a.spouseName!, Icons.favorite_outline),
      ('Registered On', registeredOn, Icons.calendar_today_outlined),
    ];

    return ListView(
      padding: EdgeInsets.all(context.pagePad),
      children: [
        Container(
          padding: EdgeInsets.all(context.cardPad),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(context.cardRadius),
            boxShadow: context.cardShadow,
          ),
          child: Column(
            children: fields
                .map((f) => _infoRow(context, f.$3, f.$1, f.$2))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
      BuildContext context, IconData icon, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: cs.primary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: context.sp(11),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: context.sp(13),
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await Session.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                foregroundColor: Colors.white),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
