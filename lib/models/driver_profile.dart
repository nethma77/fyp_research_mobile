class DriverProfile {
  final String id;
  final String name;
  final String email;
  final double rating;

  DriverProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.rating,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json, String id) {
    return DriverProfile(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'rating': rating,
    };
  }
}
