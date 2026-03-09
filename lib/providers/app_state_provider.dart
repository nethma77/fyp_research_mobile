import 'package:flutter/material.dart';
import '../models/driver_profile.dart';
import '../models/trip.dart';
import '../services/firestore_service.dart';

class AppStateProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  DriverProfile? _profile;
  final List<Trip> _trips = [];
  bool _isLoading = false;

  DriverProfile? get profile => _profile;
  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;

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
}
