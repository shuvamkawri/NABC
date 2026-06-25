import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../models/user_model.dart';
import '../widgets/status_badge.dart';

class MyTransportationScreen extends StatelessWidget {
  const MyTransportationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transportList = [
      MyTransportation(id: '1', type: 'Shuttle Bus', from: 'Hampton Inn White Plains', to: 'Westchester County Center', date: 'July 3, 2026', time: '5:30 PM', status: 'Confirmed', seats: 1),
      MyTransportation(id: '2', type: 'Shuttle Bus', from: 'Westchester County Center', to: 'Hampton Inn White Plains', date: 'July 3, 2026', time: '11:00 PM', status: 'Confirmed', seats: 1),
      MyTransportation(id: '3', type: 'Shuttle Bus', from: 'Hampton Inn White Plains', to: 'Westchester County Center', date: 'July 4, 2026', time: '7:00 AM', status: 'Pending', seats: 1),
      MyTransportation(id: '4', type: 'Shuttle Bus', from: 'Hampton Inn White Plains', to: 'Westchester County Center', date: 'July 5, 2026', time: '7:00 AM', status: 'Pending', seats: 1),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Transportation')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBanner(context),
            const SizedBox(height: 16),
            _buildShuttleInfo(context),
            const SizedBox(height: 20),
            Text(
              'My Bookings',
              style: TextStyle(
                fontSize: context.sp(15),
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...transportList.map((t) => _buildTransportTile(context, t)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.cardPad),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0277BD), Color(0xFF29B6F6)],
        ),
        borderRadius: BorderRadius.circular(context.cardRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_bus, color: Colors.white, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shuttle Service',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: context.sp(15),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Every 15–20 min during peak hours',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: context.sp(12),
                  ),
                ),
                Text(
                  'Free for all registered attendees',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: context.sp(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShuttleInfo(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final schedule = [
      ('Morning', '7:00 AM – 10:00 AM', Icons.wb_sunny_outlined),
      ('Afternoon', '12:00 PM – 2:00 PM', Icons.wb_cloudy_outlined),
      ('Evening', '5:00 PM – 7:00 PM', Icons.wb_twilight_outlined),
      ('Night Return', '10:00 PM – 12:00 AM', Icons.nights_stay_outlined),
    ];

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
          Text(
            'Shuttle Schedule',
            style: TextStyle(
              fontSize: context.sp(15),
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...schedule.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(s.$3, color: cs.primary, size: 18),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: context.wp(22).clamp(78.0, 100.0),
                      child: Text(
                        s.$1,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(12),
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        s.$2,
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: context.sp(12),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTransportTile(BuildContext context, MyTransportation t) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_bus_outlined,
                        size: 12, color: cs.primary),
                    const SizedBox(width: 4),
                    Text(
                      t.type,
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: context.sp(11),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              StatusBadge(status: t.status, compact: true),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.successGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.from,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(12),
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(
              width: 2,
              height: 12,
              color: context.textSecondary.withValues(alpha: 0.4),
              margin: const EdgeInsets.symmetric(vertical: 2),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, size: 10, color: AppColors.accentRed),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.to,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(12),
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 12, color: context.textSecondary),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${t.date} at ${t.time}',
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: context.sp(11),
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.airline_seat_recline_normal_outlined,
                  size: 12, color: context.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${t.seats} seat',
                style: TextStyle(
                  fontSize: context.sp(11),
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}