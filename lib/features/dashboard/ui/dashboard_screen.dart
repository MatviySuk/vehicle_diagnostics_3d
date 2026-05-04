import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vehicle/logic/vehicle_providers.dart';
import '../../auth/logic/auth_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleStatusAsync = ref.watch(vehicleStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Diagnostics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Maintenance History',
            onPressed: () => context.push('/history'),
          ),
          IconButton(
            icon: const Icon(Icons.view_in_ar),
            tooltip: '3D Car View',
            onPressed: () => context.push('/3d-view'),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan Part',
            onPressed: () async {
              final result = await context.push<String>('/scanner');
              if (result != null && context.mounted) {
                context.push('/component/$result');
              }
            },
          ),

          // ING: Logout button — clears the session and returns to the welcome screen.
          // PT: Botão de logout — limpa a sessão e regressa ao ecrã de boas-vindas.
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go('/welcome');
            },
          ),
        ],
      ),
      body: vehicleStatusAsync.when(
        loading: () => const Center(child: CircularProgressProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (status) => RefreshIndicator(
          onRefresh: () => ref.refresh(vehicleStatusProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _InfoCard(title: 'VIN', value: status.vin),
              _InfoCard(title: 'Mileage', value: '${status.mileageKm} km'),
              _InfoCard(
                title: 'Doors',
                value: status.isDoorsLocked ? 'Locked' : 'Unlocked',
                color: status.isDoorsLocked ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              const Text('Tire Pressures (bar)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _InfoCard(title: 'Front Left', value: status.frontLeftTirePressure.toString())),
                  Expanded(child: _InfoCard(title: 'Front Right', value: status.frontRightTirePressure.toString())),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _InfoCard(title: 'Rear Left', value: status.rearLeftTirePressure.toString())),
                  Expanded(child: _InfoCard(title: 'Rear Right', value: status.rearRightTirePressure.toString())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _InfoCard({required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressProgressIndicator extends StatelessWidget {
  const CircularProgressProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Fetching vehicle status...'),
      ],
    );
  }
}