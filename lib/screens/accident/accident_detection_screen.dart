import 'package:flutter/material.dart';

class AccidentDetectionScreen extends StatelessWidget {
  const AccidentDetectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident Detection'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text('Accident Detection Active', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Monitoring sensors for sudden deceleration or impact...',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // Simulate alarm override
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SOS Alert Triggered Manually')));
              },
              child: const Text('Manual SOS Alert', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
