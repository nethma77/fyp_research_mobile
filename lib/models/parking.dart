class Parking {
  final String id;
  final String locationName;
  final double latitude;
  final double longitude;
  final String status; // 'parked', 'departed'
  final DateTime parkedTime;
  final DateTime? departedTime;
  final double cost;

  Parking({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.parkedTime,
    this.departedTime,
    required this.cost,
  });

  factory Parking.fromJson(Map<String, dynamic> json, String id) {
    return Parking(
      id: id,
      locationName: json['locationName'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'parked',
      parkedTime: json['parkedTime'] != null ? DateTime.parse(json['parkedTime']) : DateTime.now(),
      departedTime: json['departedTime'] != null ? DateTime.parse(json['departedTime']) : null,
      cost: (json['cost'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'parkedTime': parkedTime.toIso8601String(),
      'departedTime': departedTime?.toIso8601String(),
      'cost': cost,
    };
  }
}
