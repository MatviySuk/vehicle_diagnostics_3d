import 'package:go_router/go_router.dart';
import '../../features/auth/ui/splash_screen.dart';
import '../../features/auth/ui/welcome_screen.dart';
import '../../features/dashboard/ui/dashboard_screen.dart';
import '../../features/maintenance/ui/maintenance_history_screen.dart';
import '../../features/scanner/ui/qr_scanner_screen.dart';
import '../../features/vehicle/ui/car_3d_screen.dart';
import '../../features/vehicle/ui/component_detail_screen.dart';

/**********
 * ING: Central router for the app. Always starts at /splash, which decides
 *      the next destination based on whether a session exists.
 * PT: Router central da app. Começa sempre em /splash, que decide
 *     o destino seguinte consoante a existência de sessão.
 ****/
final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [

    // ING: Auth routes.
    // PT: Rotas de autenticação.
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),

    // ING: App routes.
    // PT: Rotas da aplicação.
    GoRoute(
      path: '/dashboard',
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