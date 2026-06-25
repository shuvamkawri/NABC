/// A hotel/accommodation booking from
/// `GET /api-attendee/find-attendee-hotel`.
///
/// The endpoint returns rows from more than one table, so the shapes differ
/// between items. Every field is therefore optional and read defensively.
class HotelBooking {
  final int id;
  final String registrationNumber;
  final String hotelChoice;
  final String confirmationNumber;
  final String sponsorshipCategory;
  final String? hotelRequired;
  final int? nights;
  final int? rooms;
  final String? checkInDate;
  final String? checkOutDate;
  final String paymentStatus;
  final String? paymentMode;
  final String? amount;
  final String? notes;

  HotelBooking({
    required this.id,
    required this.registrationNumber,
    required this.hotelChoice,
    required this.confirmationNumber,
    required this.sponsorshipCategory,
    required this.hotelRequired,
    required this.nights,
    required this.rooms,
    required this.checkInDate,
    required this.checkOutDate,
    required this.paymentStatus,
    required this.paymentMode,
    required this.amount,
    required this.notes,
  });

  factory HotelBooking.fromJson(Map<String, dynamic> json) {
    String? str(String key) {
      final v = json[key];
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    int? intVal(String key) => (json[key] as num?)?.toInt();

    return HotelBooking(
      id: intVal('id') ?? 0,
      registrationNumber: str('registration_number') ?? '',
      hotelChoice: str('hotel_choice') ?? 'Hotel',
      confirmationNumber: str('confirmation_number') ?? '',
      sponsorshipCategory: str('sponsorship_category') ?? '',
      hotelRequired: str('hotel_required'),
      // One table uses number_of_nights, the other number_of_days.
      nights: intVal('number_of_nights') ?? intVal('number_of_days'),
      rooms: intVal('number_of_rooms'),
      checkInDate: str('check_in_date'),
      checkOutDate: str('check_out_date'),
      paymentStatus: str('payment_status') ?? '',
      paymentMode: str('payment_mode'),
      amount: str('amount'),
      // Prefer the customer-facing notes, then admin/finance/generic notes.
      notes: str('customer_hotel_payment_notes') ??
          str('admin_notes') ??
          str('notes'),
    );
  }
}
