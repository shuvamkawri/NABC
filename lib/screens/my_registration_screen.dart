import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../widgets/status_badge.dart';

class MyRegistrationScreen extends StatelessWidget {
  const MyRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Registration'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Column(
          children: [
            _buildRegistrationCard(context),
            const SizedBox(height: 16),
            _buildServicesGrid(context),
            const SizedBox(height: 16),
            _buildStatusHistory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.cardPad + 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.cardRadius + 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chandan Kumar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'General Registrant',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const StatusBadge(status: 'Checked'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          _regRow(context, 'Registration ID', 'NABC-2026-00842'),
          _regRow(context, 'Email', 'chandan@shanviatech.com'),
          _regRow(context, 'Phone', '+1 (555) 234-5678'),
          _regRow(context, 'Registration Date', 'May 15, 2026'),
          _regRow(context, 'Event Dates', 'July 3–5, 2026'),
        ],
      ),
    );
  }

  Widget _regRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: context.wp(32).clamp(100.0, 140.0),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    final services = [
      {
        'label': 'Hotel',
        'value': 'Hampton Inn',
        'status': 'Confirmed',
        'icon': Icons.hotel_outlined
      },
      {
        'label': 'Food',
        'value': '3-Day Coupon',
        'status': 'Confirmed',
        'icon': Icons.restaurant_outlined
      },
      {
        'label': 'Transport',
        'value': 'Shuttle Bus',
        'status': 'Checked',
        'icon': Icons.directions_bus_outlined
      },
      {
        'label': 'Volunteer',
        'value': 'Not Applied',
        'status': 'Not Checked',
        'icon': Icons.volunteer_activism_outlined
      },
    ];

    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booked Services',
          style: TextStyle(
            fontSize: context.sp(15),
            fontWeight: FontWeight.w800,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.7,
          children: services.map((s) {
            return Container(
              padding: EdgeInsets.all(context.cardPad),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(context.cardRadius),
                boxShadow: context.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(s['icon'] as IconData,
                          color: cs.primary, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          s['label'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: context.sp(12),
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    s['value'] as String,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: context.sp(11),
                    ),
                  ),
                  StatusBadge(status: s['status'] as String, compact: true),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusHistory(BuildContext context) {
    final history = [
      ('Registered', 'May 15, 2026', 'Checked'),
      ('Hotel Confirmed', 'May 18, 2026', 'Confirmed'),
      ('Food Coupon Issued', 'May 20, 2026', 'Confirmed'),
      ('Check-in Pending', 'July 3, 2026', 'Pending'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Timeline',
          style: TextStyle(
            fontSize: context.sp(15),
            fontWeight: FontWeight.w800,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...history.map((h) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(context.cardPad),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(context.cardRadius),
                boxShadow: context.cardShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.$1,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: context.sp(13),
                            color: context.textPrimary,
                          ),
                        ),
                        Text(
                          h.$2,
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: context.sp(11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: h.$3, compact: true),
                ],
              ),
            )),
      ],
    );
  }
}