/// Attendee returned by `POST /api/find-attendee`.
class Attendee {
  final int id;
  final int? registrationId;
  final String registrationNumber;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String attendeeType;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;
  final DateTime? createdAt;
  final String? spouseFirstName;
  final String? spouseMiddleName;
  final String? spouseLastName;

  Attendee({
    required this.id,
    required this.registrationId,
    required this.registrationNumber,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.attendeeType,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.createdAt,
    required this.spouseFirstName,
    required this.spouseMiddleName,
    required this.spouseLastName,
  });

  /// Serializes back to the same snake_case shape as the API response, so it
  /// can be persisted and re-read via [Attendee.fromJson].
  Map<String, dynamic> toJson() => {
        'id': id,
        'registration_id': registrationId,
        'registration_number': registrationNumber,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'gender': gender,
        'attendee_type': attendeeType,
        'address': address,
        'city': city,
        'state': state,
        'zip': zip,
        'country': country,
        'created_at': createdAt?.toIso8601String(),
        'spouse_first_name': spouseFirstName,
        'spouse_middle_name': spouseMiddleName,
        'spouse_last_name': spouseLastName,
      };

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: (json['id'] as num?)?.toInt() ?? 0,
      registrationId: (json['registration_id'] as num?)?.toInt(),
      registrationNumber: json['registration_number']?.toString() ?? '',
      fullName: (json['full_name']?.toString() ?? '').trim(),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      attendeeType: json['attendee_type']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zip: json['zip']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      spouseFirstName: json['spouse_first_name']?.toString(),
      spouseMiddleName: json['spouse_middle_name']?.toString(),
      spouseLastName: json['spouse_last_name']?.toString(),
    );
  }

  /// Full spouse name built from the parts, or null if none provided.
  String? get spouseName {
    final parts = [spouseFirstName, spouseMiddleName, spouseLastName]
        .where((p) => p != null && p.trim().isNotEmpty)
        .map((p) => p!.trim())
        .toList();
    return parts.isEmpty ? null : parts.join(' ');
  }

  /// One-line address, e.g. "42 Asbury Park Ct, Sugar Land, TX 77479".
  String get fullAddress {
    final cityState = [
      city,
      [state, zip].where((p) => p.trim().isNotEmpty).join(' '),
    ].where((p) => p.trim().isNotEmpty).join(', ');
    return [address, cityState]
        .where((p) => p.trim().isNotEmpty)
        .join(', ');
  }
}
