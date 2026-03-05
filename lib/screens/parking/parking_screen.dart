import 'package:flutter/material.dart';

class ParkingScreen extends StatelessWidget {
  const ParkingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return const Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.local_parking, color: Colors.blue),
              title: Text('City Center Mall Parking'),
              subtitle: Text('Duration: 2 hours\nCost: \$10.00'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
