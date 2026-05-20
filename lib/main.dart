import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/device/device_id_provider.dart';
import 'core/router/app_router.dart';
import 'features/vehicle/ui/car_3d_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final game = SimpleGame3D();
  game.startPreloading(); // parse dos modelos em background enquanto a app arranca

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        car3dGameProvider.overrideWithValue(game),
      ],
      child: const VehicleDiagnosticsApp(),
    ),
  );
}

class VehicleDiagnosticsApp extends StatelessWidget {
  const VehicleDiagnosticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vehicle Diagnostics 3D',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
