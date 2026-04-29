import 'package:go_router/go_router.dart';
import '../../features/dashboard/ui/dashboard_screen.dart';
import '../../features/maintenance/ui/maintenance_history_screen.dart';
import '../../features/scanner/ui/qr_scanner_screen.dart';
import '../../features/vehicle/ui/car_3d_screen.dart';
import '../../features/vehicle/ui/component_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const QRScannerScreen(),
    ),
    GoRoute(
      path: '/3d-view',
      builder: (context, state) => const Car3DScreen(),
    ),
    GoRoute(
      path: '/component/:id',
      builder: (context, state) {
        final componentId = state.pathParameters['id']!;
        return ComponentDetailScreen(componentId: componentId);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const MaintenanceHistoryScreen(),
    ),
  ],
);
