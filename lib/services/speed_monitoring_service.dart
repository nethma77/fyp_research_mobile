import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../services/firestore_service.dart';
import '../providers/auth_provider.dart';

class SpeedMonitoringService {
  static final SpeedMonitoringService _instance = SpeedMonitoringService._internal();
  factory SpeedMonitoringService() => _instance;
  SpeedMonitoringService._internal();

  Timer? _monitoringTimer;
  bool _isMonitoring = false;
  final Random _random = Random();
  BuildContext? _currentContext;
  AuthProvider? _currentAuthProvider;

  // Speed limits for different zones
  static const Map<String, int> _speedLimits = {
    'School Zone': 30,
    'Residential Area': 50,
    'Highway': 100,
    'City Center': 60,
  };

  // Current simulated speed and location
  double _currentSpeed = 0.0;
  String _currentLocation = 'City Center';

  // Getters
  double get currentSpeed => _currentSpeed;
  String get currentLocation => _currentLocation;
  bool get isMonitoring => _isMonitoring;

  // Start monitoring speed
  void startMonitoring(BuildContext context, AuthProvider authProvider) {
    if (_isMonitoring) return;

    print('Starting speed monitoring...');
    _currentContext = context;
    _currentAuthProvider = authProvider;
    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _simulateSpeedAndLocation();
      _checkForViolations();
    });
  }

  // Stop monitoring
  void stopMonitoring() {
    print('Stopping speed monitoring...');
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _currentContext = null;
    _currentAuthProvider = null;
  }

  // Simulate speed and location changes
  void _simulateSpeedAndLocation() {
    // Random location change (20% chance)
    if (_random.nextDouble() < 0.2) {
      final locations = _speedLimits.keys.toList();
      _currentLocation = locations[_random.nextInt(locations.length)];
    }

    // Simulate speed based on location and some randomness
    final baseSpeed = _speedLimits[_currentLocation]! + _random.nextInt(40) - 10; // -10 to +30
    _currentSpeed = max(0, baseSpeed.toDouble()); // Ensure non-negative

    print('Simulation: Location: $_currentLocation, Speed: ${_currentSpeed.toStringAsFixed(1)} km/h');
  }

  // Check for speed violations
  void _checkForViolations() {
    final speedLimit = _speedLimits[_currentLocation]!;
    final violationThreshold = speedLimit + 10; // Allow 10km/h over limit before violation

    print('Speed check: $_currentSpeed km/h at $_currentLocation (limit: $speedLimit, threshold: $violationThreshold)');

    if (_currentSpeed > violationThreshold) {
      print('Violation detected! Speed: $_currentSpeed, Limit: $speedLimit');
      _createSpeedViolation();
    }
  }

  // Create a speed violation
  void _createSpeedViolation() async {
    final driverId = _currentAuthProvider?.user?.uid;
    if (driverId == null) {
      print('No driver ID available');
      return;
    }

    print('Creating violation for driver: $driverId');

    final violation = Violation(
      id: '', // Will be set by Firestore
      driverId: driverId,
      timestamp: DateTime.now(),
      type: 'speeding',
      location: _currentLocation,
      status: 'pending',
    );

    // Save to Firestore
    final firestoreService = FirestoreService();
    final success = await firestoreService.addViolation(violation);

    print('Violation saved to Firestore: $success');

    if (success && _currentContext != null && _currentContext!.mounted) {
      print('Context is mounted, showing popup');
      // Show violation popup
      _showViolationPopup(_currentContext!, violation);
    } else {
      print('Context not mounted or save failed: context=${_currentContext}, mounted=${_currentContext?.mounted}, success=$success');
    }
  }

// Show violation popup
  void _showViolationPopup(BuildContext context, Violation violation) {
    print('Showing violation popup for: ${violation.location}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text('Speed Violation Alert!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Speed Limit Exceeded',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              Text('Location: ${violation.location}'),
              Text('Your Speed: ${_currentSpeed.toStringAsFixed(0)} km/h'),
              Text('Speed Limit: ${_speedLimits[violation.location]} km/h'),
              const SizedBox(height: 10),
              const Text(
                'Please slow down immediately to avoid further violations.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Acknowledge'),
            ),
          ],
        );
      },
    );
  }

  // Manual trigger for testing (can be called from UI)
  void triggerTestViolation() {
    _currentSpeed = 120.0; // Force high speed
    _currentLocation = 'School Zone';
    _createSpeedViolation();
  }
}