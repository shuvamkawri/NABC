/// A single meal slot with veg / non-veg coupon counts.
class MealSlot {
  final String day; // 'Friday', 'Saturday', 'Sunday'
  final String meal; // 'Lunch', 'Dinner'
  final int veg;
  final int nonVeg;

  const MealSlot({
    required this.day,
    required this.meal,
    required this.veg,
    required this.nonVeg,
  });

  int get total => veg + nonVeg;
}

/// A food booking from `GET /api-attendee/find-attendee-food`.
class FoodBooking {
  final int id;
  final String registrationNumber;
  final String paymentMethod;
  final String paymentStatus;
  final String totalPrice;
  final String? dietaryRestrictions;
  final String? additionalNotes;
  final List<MealSlot> meals;

  FoodBooking({
    required this.id,
    required this.registrationNumber,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalPrice,
    required this.dietaryRestrictions,
    required this.additionalNotes,
    required this.meals,
  });

  /// Total number of meal coupons across all days/meals.
  int get totalCoupons => meals.fold(0, (sum, m) => sum + m.total);

  factory FoodBooking.fromJson(Map<String, dynamic> json) {
    String? str(String key) {
      final v = json[key];
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    int count(String key) => (json[key] as num?)?.toInt() ?? 0;

    const days = [
      ('fri', 'Friday'),
      ('sat', 'Saturday'),
      ('sun', 'Sunday'),
    ];
    const mealsOfDay = [
      ('lunch', 'Lunch'),
      ('dinner', 'Dinner'),
    ];

    final meals = <MealSlot>[];
    for (final (dKey, dLabel) in days) {
      for (final (mKey, mLabel) in mealsOfDay) {
        meals.add(MealSlot(
          day: dLabel,
          meal: mLabel,
          veg: count('${dKey}_${mKey}_veg'),
          nonVeg: count('${dKey}_${mKey}_nonveg'),
        ));
      }
    }

    return FoodBooking(
      id: (json['id'] as num?)?.toInt() ?? 0,
      registrationNumber: str('registration_number') ?? '',
      paymentMethod: str('payment_method') ?? '',
      paymentStatus: str('payment_status') ?? '',
      totalPrice: str('total_price') ?? '0.00',
      dietaryRestrictions: str('dietary_restrictions'),
      additionalNotes: str('additional_notes'),
      meals: meals,
    );
  }
}
