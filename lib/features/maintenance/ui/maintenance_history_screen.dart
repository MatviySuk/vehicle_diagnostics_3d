import 'package:flutter/material.dart';

class MaintenanceHistoryScreen extends StatelessWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance History')),
      body: const Center(
        child: Text('History List (Mahmud)'),
      ),
    );
  }
}
