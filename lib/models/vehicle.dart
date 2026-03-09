class Vehicle {
  final String id;
  final String vehicleType;
  final String numberPlate;

  Vehicle({
    required this.id,
    required this.vehicleType,
    required this.numberPlate,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json, String id) {
    return Vehicle(
      id: id,
      vehicleType: json['vehicleType'] ?? '',
      numberPlate: json['numberPlate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleType': vehicleType,
      'numberPlate': numberPlate,
    };
  }
}