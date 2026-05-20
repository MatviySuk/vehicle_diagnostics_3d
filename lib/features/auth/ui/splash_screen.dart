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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.pink.withAlpha(90), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.pinkAccent.withAlpha(60), Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink.withAlpha(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withAlpha(60),
                        blurRadius: 32,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    size: 64,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Vehicle Diagnostics',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '3 D',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 8,
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 56),
                  child: CircularProgressIndicator(
                    color: Colors.pink,
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}