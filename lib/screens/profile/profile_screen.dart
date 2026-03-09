import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/vehicle.dart';
import '../../utils/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Vehicle> _vehicles = [];
  bool _showVehicleForm = false;
  String? _selectedVehicleType;
  final _numberPlateController = TextEditingController();

  final List<String> _vehicleTypes = [
    'Car',
    'Van',
    'Bike',
    'Lorry',
    'Bus',
    'Truck',
    'Motorcycle',
    'SUV',
    'Pickup',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final auth = context.read<AuthProvider>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    final vehicles = await FirestoreService().getDriverVehicles(uid);
    setState(() {
      _vehicles = vehicles;
    });
  }

  Future<void> _addVehicle() async {
    if (_selectedVehicleType == null || _numberPlateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all vehicle fields')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    final success = await FirestoreService().addDriverVehicle(uid, {
      'vehicleType': _selectedVehicleType!,
      'numberPlate': _numberPlateController.text.trim(),
    });

    if (success) {
      _numberPlateController.clear();
      setState(() {
        _selectedVehicleType = null;
        _showVehicleForm = false;
      });
      _loadVehicles();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle added')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add vehicle')),
      );
    }
  }

  @override
  void dispose() {
    _numberPlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                auth.userName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                auth.userEmail,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Vehicles Section
              const Text(
                'My Vehicles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              if (_vehicles.isEmpty)
                const Text('No vehicles added yet.', style: TextStyle(color: Colors.grey)),

              // Vehicle Cards
              ..._vehicles.map((vehicle) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(vehicle.vehicleType),
                  subtitle: Text(vehicle.numberPlate),
                ),
              )),

              const SizedBox(height: 16),

              // Add Vehicle Button
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showVehicleForm = !_showVehicleForm;
                  });
                },
                icon: Icon(_showVehicleForm ? Icons.close : Icons.add),
                label: Text(_showVehicleForm ? 'Cancel' : 'Add a Vehicle'),
              ),

              // Vehicle Form
              if (_showVehicleForm) ...[
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    value: _selectedVehicleType,
                    hint: const Text('Select Vehicle Type'),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _vehicleTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedVehicleType = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _numberPlateController,
                  decoration: const InputDecoration(
                    labelText: 'Number Plate',
                    hintText: 'ABC-1234',
                    prefixIcon: Icon(Icons.confirmation_number),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addVehicle,
                  child: const Text('Add Vehicle'),
                ),
              ],

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await context.read<AuthProvider>().signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (route) => false);
                  }
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
