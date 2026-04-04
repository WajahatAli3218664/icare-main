import 'user.dart';

class Doctor {
  final String id;
  final User user;
  final String? specialization;
  final List<String> consultationType;
  final List<String> languages;
  final List<String> degrees;
  final String? experience;
  final String? licenseNumber;
  final String? clinicName;
  final String? clinicAddress;
  final List<String> availableDays;
  final AvailableTime? availableTime;
  final bool isApproved;
  final List<double> ratings;
  final List<String> reviews;

  Doctor({
    required this.id,
    required this.user,
    this.specialization,
    this.consultationType = const [],
    this.languages = const [],
    this.degrees = const [],
    this.experience,
    this.licenseNumber,
    this.clinicName,
    this.clinicAddress,
    this.availableDays = const [],
    this.availableTime,
    this.isApproved = false,
    this.ratings = const [],
    this.reviews = const [],
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    List<String> parseConsultationType(dynamic value) {
      if (value == null) return [];
      if (value is String) return [value];
      if (value is List) return List<String>.from(value);
      return [];
    }

    // Backend flat format: { id, name, email, availableTime: "9AM-4PM" }
    // Standalone format:   { _id, user: {...}, availableTime: { start, end } }
    final isFlat = json['user'] == null;

    final userMap = isFlat
        ? {
            'id': json['id']?.toString() ?? '',
            '_id': json['id']?.toString() ?? '',
            'username': json['name'] ?? json['username'] ?? '',
            'name': json['name'] ?? json['username'] ?? '',
            'email': json['email'] ?? '',
            'phone': json['phoneNumber'] ?? json['phone'] ?? '',
            'phoneNumber': json['phoneNumber'] ?? json['phone'] ?? '',
            'role': json['role'] ?? 'doctor',
          }
        : Map<String, dynamic>.from(json['user'] as Map);

    // availableTime can be "9AM - 4PM" string or { start, end } map
    AvailableTime? parseAvailableTime(dynamic value) {
      if (value == null) return null;
      if (value is Map) {
        return AvailableTime.fromJson(Map<String, dynamic>.from(value));
      }
      if (value is String && value.contains('-')) {
        final parts = value.split('-');
        return AvailableTime(start: parts[0].trim(), end: parts[1].trim());
      }
      return null;
    }

    return Doctor(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      user: User.fromJson(userMap),
      specialization: json['specialization'],
      consultationType: parseConsultationType(json['consultationType']),
      languages: json['languages'] != null ? List<String>.from(json['languages']) : [],
      degrees: json['degrees'] != null ? List<String>.from(json['degrees']) : [],
      experience: json['experience']?.toString(),
      licenseNumber: json['licenseNumber'],
      clinicName: json['clinicName'],
      clinicAddress: json['clinicAddress'],
      availableDays: json['availableDays'] != null ? List<String>.from(json['availableDays']) : [],
      availableTime: parseAvailableTime(json['availableTime']),
      isApproved: json['isApproved'] ?? true,
      ratings: json['ratings'] != null
          ? List<double>.from(json['ratings'].map((r) => (r as num).toDouble()))
          : json['rating'] != null ? [double.tryParse(json['rating'].toString()) ?? 0.0] : [],
      reviews: json['reviews'] != null ? List<String>.from(json['reviews']) : [],
    );
  }

  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  int get reviewCount => reviews.length;
}

class AvailableTime {
  final String start;
  final String end;

  AvailableTime({
    required this.start,
    required this.end,
  });

  factory AvailableTime.fromJson(Map<String, dynamic> json) {
    return AvailableTime(
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}
