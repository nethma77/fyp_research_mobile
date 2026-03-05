class DriverProfile {
  final String id;
  final String name;
  final String email;
  final String vehicleType;
  final String licenseNumber;
  final double rating;

  DriverProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.vehicleType,
    required this.licenseNumber,
    required this.rating,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json, String id) {
    return DriverProfile(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'vehicleType': vehicleType,
      'licenseNumber': licenseNumber,
      'rating': rating,
    };
  }
}
