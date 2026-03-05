class Trip {
  final String id;
  final String driverId;
  final String startLocation;
  final String endLocation;
  final DateTime startTime;
  final DateTime? endTime;
  final double distance;
  final String status; // 'active', 'completed', 'cancelled'

  Trip({
    required this.id,
    required this.driverId,
    required this.startLocation,
    required this.endLocation,
    required this.startTime,
    this.endTime,
    required this.distance,
    required this.status,
  });

  factory Trip.fromJson(Map<String, dynamic> json, String id) {
    return Trip(
      id: id,
      driverId: json['driverId'] ?? '',
      startLocation: json['startLocation'] ?? '',
      endLocation: json['endLocation'] ?? '',
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : DateTime.now(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      distance: (json['distance'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'distance': distance,
      'status': status,
    };
  }
}
