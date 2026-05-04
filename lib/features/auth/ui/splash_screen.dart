import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../logic/auth_providers.dart';

/**********
 * ING: Entry screen shown on every launch. Waits briefly then redirects
 *      to /dashboard if a session exists, otherwise to /welcome.
 * PT: Ecrã de entrada mostrado em cada arranque. Aguarda brevemente e redireciona
 *     para /dashboard se existir sessão, caso contrário para /welcome.
 ****/
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ING: Redirect after a short delay to allow the screen to render.
    // PT: Redireciona após um curto atraso para permitir que o ecrã seja renderizado.
    Future.delayed(const Duration(milliseconds: 1600), _redirect);
  }

  void _redirect() {
    if (!mounted) return;
    final isAuth = ref.read(isAuthenticatedProvider);
    context.go(isAuth ? '/dashboard' : '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Vehicle Diagnostics 3D'),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}