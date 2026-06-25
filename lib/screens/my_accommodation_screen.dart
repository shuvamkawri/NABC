import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/responsive.dart';
import '../utils/session.dart';
import '../models/hotel_booking_model.dart';
import '../services/attendee_service.dart';
import '../widgets/async_views.dart';
import '../widgets/status_badge.dart';

class MyAccommodationScreen extends StatefulWidget {
  const MyAccommodationScreen({super.key});

  @override
  State<MyAccommodationScreen> createState() => _MyAccommodationScreenState();
}

class _MyAccommodationScreenState extends State<MyAccommodationScreen> {
  late Future<List<HotelBooking>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<HotelBooking>> _load() {
    final reg = Session.current?.registrationNumber ?? '';
    if (reg.isEmpty) {
      return Future.error(
          AttendeeException('You are not signed in. Please log in again.'));
    }
    return AttendeeService.findHotels(reg);
  }

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Accommodation')),
      body: FutureBuilder<List<HotelBooking>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorRetryView(
              message: snapshot.error.toString(),
              onRetry: _retry,
            );
          }
          final hotels = snapshot.data ?? const [];
          if (hotels.isEmpty) {
            return const EmptyView(
              icon: Icons.hotel_outlined,
              message: 'No accommodation data found.',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _retry(),
            child: ListView.separated(
              padding: EdgeInsets.all(context.pagePad),
              itemCount: hotels.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _HotelCard(hotel: hotels[i]),
            ),
          );
        },
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final HotelBooking hotel;
  const _HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius + 2),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        children: [
          // Header band
          Container(
            padding: EdgeInsets.all(context.cardPad),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.cardRadius + 2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.hotel, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _titleCase(hotel.hotelChoice),
                        style: TextStyle(
                          fontSize: context.sp(17),
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (hotel.sponsorshipCategory.isNotEmpty)
                        Text(
                          '${hotel.sponsorshipCategory} Sponsorship',
                          style: TextStyle(
                            fontSize: context.sp(11),
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
                if (hotel.nights != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${hotel.nights} ${hotel.nights == 1 ? 'Night' : 'Nights'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: context.sp(11),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.cardPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (hotel.paymentStatus.isNotEmpty)
                      StatusBadge(status: hotel.paymentStatus),
                  ],
                ),
                const SizedBox(height: 12),
                _row(context, 'Check-in', _fmtDate(hotel.checkInDate)),
                _row(context, 'Check-out', _fmtDate(hotel.checkOutDate)),
                if (hotel.rooms != null)
                  _row(context, 'Rooms', '${hotel.rooms}'),
                if (hotel.confirmationNumber.isNotEmpty)
                  _row(context, 'Confirmation #', hotel.confirmationNumber),
                if (hotel.amount != null)
                  _row(context, 'Amount', '\$${hotel.amount}'),
                if (hotel.paymentMode != null)
                  _row(context, 'Payment', hotel.paymentMode!),
                if (hotel.hotelRequired != null)
                  _row(context, 'Hotel Required', hotel.hotelRequired!),
                if (hotel.notes != null) _row(context, 'Notes', hotel.notes!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.wp(30).clamp(100.0, 140.0),
            child: Text(
              label,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: context.sp(12),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: context.sp(12),
                color: context.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat('MMM d, yyyy').format(parsed);
  }

  String _titleCase(String s) => s
      .split(RegExp(r'\s+'))
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
