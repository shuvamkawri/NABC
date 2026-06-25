
class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String hall;
  final String imageUrl;
  final String category;
  final String status;
  final List<String> performers;
  final bool isFeatured;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    this.hall = '',
    required this.imageUrl,
    required this.category,
    this.status = '',
    required this.performers,
    this.isFeatured = false,
  });

  /// Builds an [Event] from one item of the backend `GET /api-attendee/events`
  /// `data` array. Tolerant of missing/null fields and of `performers` being
  /// either a list of strings or a list of objects with a `name`.
  factory Event.fromJson(Map<String, dynamic> json) {
    String str(dynamic v) => v?.toString().trim() ?? '';

    final performers = <String>[];
    final rawPerformers = json['performers'];
    if (rawPerformers is List) {
      for (final p in rawPerformers) {
        if (p is Map) {
          final name = str(p['name']);
          if (name.isNotEmpty) performers.add(name);
        } else {
          final name = str(p);
          if (name.isNotEmpty) performers.add(name);
        }
      }
    }

    return Event(
      id: str(json['id']),
      title: str(json['title']),
      description: str(json['description']),
      date: str(json['date']),
      time: str(json['time']),
      location: str(json['location']),
      hall: str(json['hall']),
      imageUrl: str(json['imageUrl'] ?? json['image']),
      category: str(json['category']),
      status: str(json['status']),
      performers: performers,
    );
  }
}

class Performer {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final String bio;
  final String country;

  Performer({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.bio,
    required this.country,
  });
}

class Sponsor {
  final String id;
  final String name;
  final String logo;
  final String website;
  final String sponsorshipLevel; // Gold, Silver, Bronze, etc.
  final String description;

  Sponsor({
    required this.id,
    required this.name,
    required this.logo,
    required this.website,
    required this.sponsorshipLevel,
    required this.description,
  });
}

class Accommodation {
  final String id;
  final String name;
  final String address;
  final double distanceFromVenue;
  final int travelTimeMinutes;
  final double ratePerNight;
  final String imageUrl;
  final String phone;
  final String website;
  final List<String> amenities;
  final String tier; // Premium, Standard

  Accommodation({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceFromVenue,
    required this.travelTimeMinutes,
    required this.ratePerNight,
    required this.imageUrl,
    required this.phone,
    required this.website,
    required this.amenities,
    required this.tier,
  });
}

class Organization {
  final String id;
  final String name;
  final String logo;
  final String website;
  final String location;
  final String description;

  Organization({
    required this.id,
    required this.name,
    required this.logo,
    required this.website,
    required this.location,
    required this.description,
  });
}

class NewsItem {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
  });
}