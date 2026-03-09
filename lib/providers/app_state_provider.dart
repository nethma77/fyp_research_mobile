import 'package:flutter/material.dart';
import '../models/driver_profile.dart';
import '../models/trip.dart';
import '../services/firestore_service.dart';
import '../services/speed_monitoring_service.dart';
import 'auth_provider.dart';

class AppStateProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final SpeedMonitoringService _speedService = SpeedMonitoringService();

  DriverProfile? _profile;
  final List<Trip> _trips = [];
  bool _isLoading = false;

  DriverProfile? get profile => _profile;
  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;
  SpeedMonitoringService get speedService => _speedService;

  Future<void> fetchAppData(String driverId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch data here. For demo, we are just generating dummy data first
      await _firestoreService.generateDummyData(driverId);

      // In a real app, you would fetch actual data:
      // final profileData = await _firestoreService.getDriverProfile(driverId);
      // _profile = DriverProfile.fromJson(profileData, driverId);
    } catch (e) {
      print('Error loading app data: \$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setActiveTrip(Trip trip) {
    // Logic for updating current active trip
    notifyListeners();
  }

  // Start speed monitoring when user logs in
  void startSpeedMonitoring(BuildContext context, AuthProvider authProvider) {
    _speedService.startMonitoring(context, authProvider);
  }

  // Stop speed monitoring when user logs out
  void stopSpeedMonitoring() {
    _speedService.stopMonitoring();
  }
}
