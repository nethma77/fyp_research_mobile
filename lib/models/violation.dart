class Violation {
  final String id;
  final String driverId;
  final DateTime timestamp;
  final String type; // 'speeding', 'running_red_light', 'illegal_parking'
  final String location;
  final double fineAmount;
  final String status; // 'pending', 'paid', 'appealed'

  Violation({
    required this.id,
    required this.driverId,
    required this.timestamp,
    required this.type,
    required this.location,
    required this.fineAmount,
    required this.status,
  });

  factory Violation.fromJson(Map<String, dynamic> json, String id) {
    return Violation(
      id: id,
      driverId: json['driverId'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      fineAmount: (json['fineAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'location': location,
      'fineAmount': fineAmount,
      'status': status,
    };
  }
}
