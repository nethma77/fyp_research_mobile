import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_state_provider.dart';

import '../home/home_screen.dart';
import '../history/trip_history_screen.dart';
import '../parking/parking_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TripHistoryScreen(),
    ParkingScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Start speed monitoring when user enters the main app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final appStateProvider = context.read<AppStateProvider>();
      appStateProvider.startSpeedMonitoring(context, authProvider);
    });
  }

  @override
  void dispose() {
    // Stop speed monitoring when leaving the main app
    final appStateProvider = context.read<AppStateProvider>();
    appStateProvider.stopSpeedMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,

        selectedItemColor: const Color(0xFF1A237E), // your primary color
        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Trips",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: "Parking",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}