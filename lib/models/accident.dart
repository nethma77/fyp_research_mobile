class Accident {
  final String id;
  final String driverId;
  final DateTime timestamp;
  final String location;
  final String severity; // 'minor', 'moderate', 'severe'
  final String description;

  Accident({
    required this.id,
    required this.driverId,
    required this.timestamp,
    required this.location,
    required this.severity,
    required this.description,
  });

  factory Accident.fromJson(Map<String, dynamic> json, String id) {
    return Accident(
      id: id,
      driverId: json['driverId'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      location: json['location'] ?? '',
      severity: json['severity'] ?? 'minor',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'severity': severity,
      'description': description,
    };
  }
}
