import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../models/user_model.dart';
import '../widgets/status_badge.dart';

class MyVolunteerScreen extends StatelessWidget {
  const MyVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final volunteer = MyVolunteer(
      id: '1',
      role: 'Event Coordinator',
      location: 'Main Stage Area — Gate B',
      shift: 'July 4, 2026 | 4:00 PM – 10:00 PM',
      status: 'Checked',
      needsHelp: false,
      helpDescription: '',
    );

    final teamMembers = [
      ('Priya Sharma', 'Team Lead', '+1 555-001'),
      ('Arjun Das', 'Coordinator', '+1 555-002'),
      ('Meena Roy', 'Assistant', '+1 555-003'),
      ('Sanjay Bose', 'Coordinator', '+1 555-004'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Volunteer')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVolunteerCard(context, volunteer),
            const SizedBox(height: 16),
            _buildLocationCard(context, volunteer),
            const SizedBox(height: 16),
            _buildHelpCard(context, volunteer),
            const SizedBox(height: 16),
            Text(
              'My Team',
              style: TextStyle(
                fontSize: context.sp(15),
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...teamMembers.map(
                (m) => _buildTeamMemberTile(context, m.$1, m.$2, m.$3)),
          ],
        ),
      ),
    );
  }

  Widget _buildVolunteerCard(BuildContext context, MyVolunteer v) {
    return Container(
      padding: EdgeInsets.all(context.cardPad + 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(context.cardRadius + 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volunteer_activism,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.role,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.sp(17),
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'NABC 2026 Volunteer',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: context.sp(12),
                      ),
                    ),
                  ],
                ),
              ),
              const StatusBadge(status: 'Checked'),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          _row(context, 'Shift', v.shift),
          _row(context, 'Volunteer ID', 'VOL-2026-0391'),
          _row(context, 'Supervisor', 'Priya Sharma'),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: context.wp(26).clamp(88.0, 120.0),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, MyVolunteer v) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'My Location',
                style: TextStyle(
                  fontSize: context.sp(15),
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, color: cs.primary, size: 30),
                  const SizedBox(height: 6),
                  Text(
                    v.location,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                      fontSize: context.sp(13),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context, MyVolunteer v) {
    return Container(
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline,
                  color: AppColors.accentRed, size: 20),
              const SizedBox(width: 8),
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: context.sp(15),
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: v.needsHelp
                  ? AppColors.accentRed.withValues(alpha: 0.1)
                  : AppColors.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Icon(
                  v.needsHelp
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: v.needsHelp
                      ? AppColors.accentRed
                      : AppColors.successGreen,
                  size: 32,
                ),
                const SizedBox(height: 6),
                Text(
                  v.needsHelp
                      ? 'Help Requested'
                      : 'All Good — No help needed',
                  style: TextStyle(
                    color: v.needsHelp
                        ? AppColors.accentRed
                        : AppColors.successGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: context.sp(13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.support_agent),
              label: const Text('Request Assistance'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberTile(
      BuildContext context, String name, String role, String phone) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: cs.primary.withValues(alpha: 0.12),
            child: Text(
              name[0],
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: context.sp(13),
                    color: context.textPrimary,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: context.sp(11),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.phone_outlined, color: cs.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}