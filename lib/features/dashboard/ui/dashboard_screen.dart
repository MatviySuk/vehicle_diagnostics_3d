import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vehicle/logic/vehicle_providers.dart';
import '../../auth/logic/auth_providers.dart';

// ING: Main dashboard screen showing live vehicle status.
// PT: Ecrã principal do dashboard com o estado do veículo em tempo real.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleStatusAsync = ref.watch(vehicleStatusProvider);

    return Scaffold(
      body: Stack(
        children: [
          // ING: Background image, centered on screen.
          // PT: Imagem de fundo centrada no ecrã.
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, 45),
                child: Image.asset(
                  'assets/images/eve-M-rtWw1OlnQ-unsplash-4.jpg',
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),

          // ING: Main content — logout button and vehicle data cards.
          // PT: Conteúdo principal — botão logout e cards de dados do veículo.
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ING: Logout button top-left.
                // PT: Botão logout topo-esquerda.
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).logout();
                    if (context.mounted) context.go('/welcome');
                  },
                ),

                // ING: Vehicle status cards — 30dp extra top padding.
                // PT: Cards de estado do veículo — 30dp de padding extra no topo.
                Expanded(
                  child: vehicleStatusAsync.when(
                    loading: () => const Center(child: _LoadingIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                    data: (status) => RefreshIndicator(
                      onRefresh: () => ref.refresh(vehicleStatusProvider.future),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 110, 16, 16),
                        children: [
                          _InfoCard(title: 'VIN', value: status.vin),
                          _InfoCard(title: 'Mileage', value: '${status.mileageKm} km'),
                          _InfoCard(
                            title: 'Doors',
                            value: status.isDoorsLocked ? 'Locked' : 'Unlocked',
                            color: status.isDoorsLocked ? Colors.green[800] : Colors.red,
                          ),
                          const SizedBox(height: 20),
                          const Text('Tire Pressures (bar)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _InfoCard(title: 'Front Left', value: status.frontLeftTirePressure.toString(), backgroundAlpha: 0.25)),
                              Expanded(child: _InfoCard(title: 'Front Right', value: status.frontRightTirePressure.toString(), backgroundAlpha: 0.25)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _InfoCard(title: 'Rear Left', value: status.rearLeftTirePressure.toString(), backgroundAlpha: 0.25)),
                              Expanded(child: _InfoCard(title: 'Rear Right', value: status.rearRightTirePressure.toString(), backgroundAlpha: 0.25)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ING: Logo — last in the Stack, always rendered on top, top-right like the 3D screen.
          // PT: Logótipo — último na Stack, sempre por cima de tudo, topo-direita como no ecrã 3D.
          Positioned(
            top: 120,
            right: 16,
            child: Image.asset(
              'assets/images/logo-App-A1.png',
              height: 60,
            ),
          ),
        ],
      ),

      // ING: 3D view FAB elevated at the centre of the bottom bar, pink colour.
      // PT: FAB da vista 3D elevado ao centro da barra inferior, cor rosa.
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/3d-view'),
        tooltip: '3D Car View',
        backgroundColor: Colors.pink,
        child: const Icon(Icons.view_in_ar, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ING: Bottom bar with history on the left and QR scanner on the right.
      // PT: Barra inferior com histórico à esquerda e scanner QR à direita.
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Maintenance History',
              onPressed: () => context.push('/history'),
            ),
            const SizedBox(width: 48),
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
          ],
        ),
      ),
    );
  }
}

// ING: Reusable semi-transparent info card for displaying a vehicle data field.
// PT: Card semi-transparente reutilizável para mostrar um campo de dados do veículo.
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  final double backgroundAlpha;

  const _InfoCard({required this.title, required this.value, this.color, this.backgroundAlpha = 0.45});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: backgroundAlpha),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.black)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color ?? Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

// ING: Loading indicator shown while vehicle data is being fetched.
// PT: Indicador de carregamento mostrado enquanto os dados do veículo são obtidos.
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Fetching vehicle status...'),
      ],
    );
  }
}
