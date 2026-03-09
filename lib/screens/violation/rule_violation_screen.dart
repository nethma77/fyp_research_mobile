import 'package:flutter/material.dart';
import '../../utils/routes.dart';

class RuleViolationScreen extends StatelessWidget {
  const RuleViolationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rule Violations Log')),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.rule, color: Colors.orange),
            title: const Text('Violation \${index + 1}'),
            subtitle: const Text('Type: Speeding\nStatus: Pending'),
            trailing: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.violationPopup),
            ),
            isThreeLine: true,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Simulate a new violation popup
          Navigator.pushNamed(context, AppRoutes.violationPopup);
        },
        child: const Icon(Icons.new_releases),
      ),
    );
  }
}
