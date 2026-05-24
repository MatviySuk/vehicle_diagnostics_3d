import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'car_3d_game.dart';
import '../logic/vehicle_cache.dart';

class Car3DScreen extends ConsumerStatefulWidget {
  const Car3DScreen({super.key});

  @override
  ConsumerState<Car3DScreen> createState() => _Car3DScreenState();
}

class _Car3DScreenState extends ConsumerState<Car3DScreen> {
  late final SimpleGame3D _game;

  @override
  void initState() {
    super.initState();
    _game = ref.read(car3dGameProvider);
  }

  bool _showHeadlightPanel = false;
  HeadlightGame? _headlightGame;

  bool _showWheelsPanel = false;
  WheelsGame? _wheelsGame;

  void _onTap(TapUpDetails details) {
    if (!_game.modelReady.value) return;
    final tap = details.localPosition;

    final headlightScreen = _game.headlightScreenPosition();
    if (headlightScreen != null && (tap - headlightScreen).distance < 50) {
      _headlightGame ??= HeadlightGame(preloadedModel: _game.headlightModel);
      setState(() => _showHeadlightPanel = true);
      Future.delayed(const Duration(seconds: 15), () {
        if (mounted) setState(() => _showHeadlightPanel = false);
      });
      return;
    }

    final wheelsScreen = _game.wheelsScreenPosition();
    if (wheelsScreen != null && (tap - wheelsScreen).distance < 50) {
      _wheelsGame ??= WheelsGame(preloadedModel: _game.wheelsModel);
      setState(() => _showWheelsPanel = true);
      Future.delayed(const Duration(seconds: 8), () {
        if (mounted) setState(() => _showWheelsPanel = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleAsync = ref.watch(cachedVehicleStatusProvider);

    final minPressure = vehicleAsync.whenOrNull(
      data: (cached) {
        final v = cached.status;
        final values = [
          v.frontLeftTirePressure,
          v.frontRightTirePressure,
          v.rearLeftTirePressure,
          v.rearRightTirePressure,
        ];
        return values.reduce((a, b) => a < b ? a : b);
      },
    );

    final isOffline = vehicleAsync.whenOrNull(data: (c) => c.fromCache) ?? false;

    final lastUpdated = vehicleAsync.whenOrNull(
      data: (c) => c.status.lastUpdated,
    );

    final pressureColor = minPressure == null
        ? Colors.grey
        : minPressure < 2.0
            ? Colors.red
            : minPressure < 2.3
                ? Colors.orange
                : Colors.green;

    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTapUp: _onTap,
        child: Stack(
          children: [
            // ING: Background image of the car, centered on screen.
            // PT: Imagem de fundo do carro, centrada no ecrã.
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/eve-M-rtWw1OlnQ-unsplash-4.jpg',
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),

            // ING: 3D car model game widget.
            // PT: Widget do jogo com o modelo 3D do carro.
            GameWidget(
              game: _game,
              loadingBuilder: (context) => const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading 3D model...'),
                  ],
                ),
              ),
            ),

            // ING: Popup panel — headlight.
            // PT: Painel popup — farol.
            if (_showHeadlightPanel)
              _ComponentPanel(
                title: 'Headlight',
                game: _headlightGame!,
                indicators: const [
                  _CircularIndicator(label: 'LED OK', value: '6000K', progress: 1.0, color: Colors.green),
                  _CircularIndicator(label: 'Usage', value: '847h', progress: 847 / 2000, color: Colors.orange),
                ],
                onClose: () => setState(() => _showHeadlightPanel = false),
                onDetail: () => context.push('/component/headlight'),
              ),

            // ING: Popup panel — wheels with live Firebase tyre pressure.
            // PT: Painel popup — rodas com pressão real do Firebase.
            if (_showWheelsPanel)
              _ComponentPanel(
                title: 'Wheels',
                game: _wheelsGame!,
                indicators: [
                  _CircularIndicator(
                    label: 'Min bar',
                    value: minPressure != null ? minPressure.toStringAsFixed(1) : '...',
                    progress: minPressure != null ? (minPressure / 2.9).clamp(0.0, 1.0) : 0.0,
                    color: pressureColor,
                  ),
                ],
                onClose: () => setState(() => _showWheelsPanel = false),
                onDetail: () => context.push('/component/wheel'),
              ),

            // ING: Offline banner — shown when data comes from local cache.
            // PT: Aviso offline — mostrado quando os dados vêm da cache local.
            if (isOffline && lastUpdated != null)
              Positioned(
                bottom: 80,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 14, color: Colors.black87),
                      const SizedBox(width: 6),
                      Text(
                        'Offline · Last sync: '
                        '${lastUpdated.hour.toString().padLeft(2, '0')}:'
                        '${lastUpdated.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

            // ING: Reset button — only visible after the model is loaded.
            // PT: Botão reset — só aparece depois do modelo carregar.
            ValueListenableBuilder<bool>(
              valueListenable: _game.modelReady,
              builder: (context, loaded, _) {
                if (!loaded) return const SizedBox.shrink();
                return Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _game.resetRotation(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),
                );
              },
            ),

            // ING: Logo — last in the Stack, always rendered on top.
            // PT: Logótipo — último na Stack, sempre por cima de tudo.
            Positioned(
              top: 20,
              right: 16,
              child: Image.asset(
                'assets/images/logo-App-A1.png',
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ING: Generic popup panel for a 3D component.
// PT: Painel popup genérico para componente 3D.
class _ComponentPanel extends StatelessWidget {
  final String title;
  final Game game;
  final List<_CircularIndicator> indicators;
  final VoidCallback onClose;
  final VoidCallback? onDetail;

  const _ComponentPanel({
    required this.title,
    required this.game,
    required this.indicators,
    required this.onClose,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50,
      right: 50,
      top: 0,
      bottom: 0,
      child: Center(
        child: AspectRatio(
          aspectRatio: 0.75,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x88808080),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  // ING: Header with title, centred details button and close button.
                  // PT: Cabeçalho com título, botão de detalhes centrado e botão fechar.
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: onDetail != null
                            ? TextButton.icon(
                                onPressed: onDetail,
                                icon: const Icon(Icons.open_in_new, color: Colors.white70, size: 16),
                                label: const Text('Details', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  side: const BorderSide(color: Colors.white30, width: 1),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white30, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 18),
                            onPressed: onClose,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ING: Rotating 3D model.
                  // PT: Modelo 3D rotativo.
                  Expanded(
                    flex: 70,
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: GameWidget(game: game),
                    ),
                  ),
                  // ING: Circular indicators.
                  // PT: Indicadores circulares.
                  Expanded(
                    flex: 30,
                    child: Transform.translate(
                      offset: const Offset(0, -30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: indicators,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ING: Reusable circular indicator widget.
// PT: Widget de indicador circular reutilizável.
class _CircularIndicator extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _CircularIndicator({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 85,
          height: 85,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}
