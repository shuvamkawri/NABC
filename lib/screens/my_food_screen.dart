import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../utils/session.dart';
import '../models/food_booking_model.dart';
import '../services/attendee_service.dart';
import '../widgets/async_views.dart';
import '../widgets/status_badge.dart';

class MyFoodScreen extends StatefulWidget {
  const MyFoodScreen({super.key});

  @override
  State<MyFoodScreen> createState() => _MyFoodScreenState();
}

class _MyFoodScreenState extends State<MyFoodScreen> {
  late Future<List<FoodBooking>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<FoodBooking>> _load() {
    final reg = Session.current?.registrationNumber ?? '';
    if (reg.isEmpty) {
      return Future.error(
          AttendeeException('You are not signed in. Please log in again.'));
    }
    return AttendeeService.findFood(reg);
  }

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Food')),
      body: FutureBuilder<List<FoodBooking>>(
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
          final bookings = snapshot.data ?? const [];
          if (bookings.isEmpty) {
            return const EmptyView(
              icon: Icons.restaurant_outlined,
              message: 'No food data found.',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _retry(),
            child: ListView(
              padding: EdgeInsets.all(context.pagePad),
              children: [
                for (final b in bookings) ...[
                  _CouponCard(booking: b),
                  const SizedBox(height: 16),
                  _MealList(booking: b),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final FoodBooking booking;
  const _CouponCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.cardPad + 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFFF9100)],
        ),
        borderRadius: BorderRadius.circular(context.cardRadius + 2),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.restaurant, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meal Coupons',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: context.sp(15),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.totalCoupons} coupons'
                  '${booking.paymentMethod.isNotEmpty ? ' • ${booking.paymentMethod}' : ''}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: context.sp(12),
                  ),
                ),
                if (double.tryParse(booking.totalPrice) != null &&
                    double.parse(booking.totalPrice) > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Total: \$${booking.totalPrice}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: context.sp(12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (booking.paymentStatus.isNotEmpty)
            StatusBadge(status: booking.paymentStatus),
        ],
      ),
    );
  }
}

class _MealList extends StatelessWidget {
  final FoodBooking booking;
  const _MealList({required this.booking});

  @override
  Widget build(BuildContext context) {
    final slots = booking.meals.where((m) => m.total > 0).toList();

    if (slots.isEmpty) {
      return Container(
        padding: EdgeInsets.all(context.cardPad),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(context.cardRadius),
          boxShadow: context.cardShadow,
        ),
        child: Text(
          'No meals selected for this booking.',
          style: TextStyle(
            color: context.textSecondary,
            fontSize: context.sp(12),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meal Schedule',
          style: TextStyle(
            fontSize: context.sp(15),
            fontWeight: FontWeight.w800,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...slots.map((s) => _MealTile(slot: s)),
        if (booking.dietaryRestrictions != null ||
            booking.additionalNotes != null) ...[
          const SizedBox(height: 4),
          if (booking.dietaryRestrictions != null)
            _noteRow(context, 'Dietary', booking.dietaryRestrictions!),
          if (booking.additionalNotes != null)
            _noteRow(context, 'Notes', booking.additionalNotes!),
        ],
      ],
    );
  }

  Widget _noteRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: context.textSecondary,
          fontSize: context.sp(12),
        ),
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  final MealSlot slot;
  const _MealTile({required this.slot});

  @override
  Widget build(BuildContext context) {
    final isDinner = slot.meal == 'Dinner';
    final color = isDinner ? const Color(0xFF6A1B9A) : const Color(0xFF1565C0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
            child: Icon(
              isDinner ? Icons.dinner_dining : Icons.lunch_dining,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${slot.day} ${slot.meal}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: context.sp(13),
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    if (slot.veg > 0)
                      _countChip(context, 'Veg', slot.veg,
                          AppColors.successGreen),
                    if (slot.nonVeg > 0)
                      _countChip(context, 'Non-Veg', slot.nonVeg,
                          AppColors.accentRed),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '×${slot.total}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: context.sp(15),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _countChip(BuildContext context, String label, int n, Color c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $n',
        style: TextStyle(
          color: c,
          fontSize: context.sp(10),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
