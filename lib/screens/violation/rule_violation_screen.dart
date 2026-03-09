import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../models/violation.dart';
import '../../providers/auth_provider.dart';
import '../../utils/routes.dart';

class RuleViolationScreen extends StatefulWidget {
  const RuleViolationScreen({super.key});

  @override
  State<RuleViolationScreen> createState() => _RuleViolationScreenState();
}

class _RuleViolationScreenState extends State<RuleViolationScreen> {
  List<Violation> _violations = [];
  bool _isLoading = true;
  StreamSubscription<QuerySnapshot>? _violationsSubscription;

  @override
  void initState() {
    super.initState();
    _setupViolationsListener();
  }

  @override
  void dispose() {
    _violationsSubscription?.cancel();
    super.dispose();
  }

  void _setupViolationsListener() {
    final authProvider = context.read<AuthProvider>();
    final driverId = authProvider.user?.uid;
    print('Setting up violations listener for driver: $driverId');
    if (driverId == null) {
      print('No driver ID available for violations listener');
      setState(() => _isLoading = false);
      return;
    }

    // Listen to violations collection for real-time updates
    // Query by driverId only (no orderBy to avoid composite index requirement)
    _violationsSubscription = FirebaseFirestore.instance
        .collection('violations')
        .where('driverId', isEqualTo: driverId)
        .snapshots()
        .listen((snapshot) {
          print('Received ${snapshot.docs.length} violations from Firestore for driver $driverId');
          final violations = snapshot.docs
              .map((doc) {
                print('Processing violation: ${doc.id} - ${doc.data()}');
                return Violation.fromJson(doc.data(), doc.id);
              })
              .toList();

          // Sort by timestamp in app (newest first)
          violations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          print('Parsed and sorted ${violations.length} violations');
          setState(() {
            _violations = violations;
            _isLoading = false;
          });
        }, onError: (error) {
          print('Error listening to violations: $error');
          setState(() => _isLoading = false);
        });
  }

  String _getViolationIcon(String type) {
    switch (type) {
      case 'speeding':
        return '🚗💨';
      case 'running_red_light':
        return '🚦🚫';
      case 'illegal_parking':
        return '🅿️🚫';
      default:
        return '⚠️';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.green;
      case 'appealed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rule Violations Log')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _violations.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 64, color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        'No violations recorded',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Keep driving safely!',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _violations.length,
                  itemBuilder: (context, index) {
                    final violation = _violations[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Text(
                          _getViolationIcon(violation.type),
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(
                          violation.type.replaceAll('_', ' ').toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location: ${violation.location}'),
                            Text('Date: ${violation.timestamp.toString().split(' ')[0]}'),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(violation.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            violation.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.violationPopup),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For testing: trigger a test violation
          final authProvider = context.read<AuthProvider>();
          // SpeedMonitoringService().triggerTestViolation(context, authProvider);
          Navigator.pushNamed(context, AppRoutes.violationPopup);
        },
        tooltip: 'Test Violation',
        child: const Icon(Icons.warning),
      ),
    );
  }
}
