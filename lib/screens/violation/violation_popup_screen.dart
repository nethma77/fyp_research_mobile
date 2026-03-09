import 'package:flutter/material.dart';

class ViolationPopupScreen extends StatelessWidget {
  const ViolationPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.gavel, size: 60, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'Rule Violation Detected',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Speed limit exceeded in School Zone. Please review your speed.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Acknowledge'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
