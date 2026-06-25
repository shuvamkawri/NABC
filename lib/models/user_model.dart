class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String registrationId;
  bool isEmailVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.registrationId,
    this.isEmailVerified = false,
  });
}

class RegistrationStatus {
  static const String checked = 'Checked';
  static const String notChecked = 'Not Checked';
  static const String dispute = 'Dispute';
  static const String resolved = 'Resolved';
}

class ProgramStatus {
  static const String onTime = 'On Time';
  static const String delayed = 'Delayed';
  static const String cancelled = 'Cancelled';
}

class MyRegistration {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String category;
  final String status;
  final String hotel;
  final String food;
  final String specialServices;
  final DateTime date;

  MyRegistration({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.category,
    required this.status,
    required this.hotel,
    required this.food,
    required this.specialServices,
    required this.date,
  });
}

class MyAccommodation {
  final String id;
  final String hotelName;
  final String checkIn;
  final String checkOut;
  final String roomType;
  final String status;
  final String confirmationNumber;

  MyAccommodation({
    required this.id,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.roomType,
    required this.status,
    required this.confirmationNumber,
  });
}

class MyFood {
  final String id;
  final String mealType;
  final String date;
  final String session;
  final String status;
  final int quantity;

  MyFood({
    required this.id,
    required this.mealType,
    required this.date,
    required this.session,
    required this.status,
    required this.quantity,
  });
}

class MyVolunteer {
  final String id;
  final String role;
  final String location;
  final String shift;
  final String status;
  final bool needsHelp;
  final String helpDescription;

  MyVolunteer({
    required this.id,
    required this.role,
    required this.location,
    required this.shift,
    required this.status,
    required this.needsHelp,
    required this.helpDescription,
  });
}

class MyTransportation {
  final String id;
  final String type;
  final String from;
  final String to;
  final String date;
  final String time;
  final String status;
  final int seats;

  MyTransportation({
    required this.id,
    required this.type,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.status,
    required this.seats,
  });
}

class AppMessage {
  final String id;
  final String title;
  final String body;
  final String type; // 'global' or 'local'
  final String targetGroup;
  final DateTime timestamp;
  bool isRead;

  AppMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.targetGroup,
    required this.timestamp,
    this.isRead = false,
  });
}

class Program {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String venue;
  final String category;
  final String status;
  final String imageUrl;

  Program({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.category,
    required this.status,
    required this.imageUrl,
  });
}

class PromoVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final String description;

  PromoVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.description,
  });
}