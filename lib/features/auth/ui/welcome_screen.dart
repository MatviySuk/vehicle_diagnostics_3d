import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../logic/auth_providers.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isScannerOpen = false;
  bool _isLoading = false;

  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _openScanner() => setState(() => _isScannerOpen = true);

  void _closeScanner() {
    _scannerController.stop();
    setState(() => _isScannerOpen = false);
    _scannerController.start();
  }

  Future<void> _onQrDetected(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    _scannerController.stop();
    setState(() => _isLoading = true);

    final success = await ref
        .read(authNotifierProvider.notifier)
        .loginWithQr(barcode.rawValue!);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      context.go('/dashboard');
    } else {
      _scannerController.start();
      setState(() => _isScannerOpen = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid QR Code. Expected format: device_XXXX-XXXX-XXXX-XXXX'),
        ),
      );
    }
  }

  Future<void> _generateNewSession() async {
    setState(() => _isLoading = true);
    await ref.read(authNotifierProvider.notifier).generateNewSession();
    if (!mounted) return;
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    if (_isScannerOpen) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          title: const Text('Scan QR Code'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _closeScanner,
          ),
        ),
        body: Stack(
          children: [
            MobileScanner(controller: _scannerController, onDetect: _onQrDetected),
            Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink, width: 2.5),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            if (_isLoading)
              const ColoredBox(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.pink),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ING: Background blobs behind all content.
          // PT: Manchas de fundo atrás de todo o conteúdo.
          const _GradientBlobs(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 2),
                      const SizedBox(height: 28),
                      Image.asset(
                        'assets/images/logo-App-A1.png',
                        height: 40,
                      ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your car\'s health, at your fingertips',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(flex: 3),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x50601dba), Color(0x30d61565)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _openScanner,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Sign in with QR Code'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _generateNewSession,
                    icon: _isLoading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF601dba),
                      ),
                    )
                        : const Icon(Icons.add_circle_outline),
                    label: _isLoading
                        ? const Text('Creating session...')
                        : const Text('Create new session'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDE1859),
                      backgroundColor: const Color(0xFFbc2f98).withAlpha(25),
                      side: const BorderSide(color: Color(0xFFc62f98), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ING: Background blobs with gradient (DesignCode style).
// PT: Manchas de fundo com degradé (estilo DesignCode).
class _GradientBlobs extends StatelessWidget {
  const _GradientBlobs();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: -95,
            right: -110,
            child: CustomPaint(
              size: const Size(320, 350),
              painter: _BlobPainter(
                colors: [
                  const Color(0xFF7B61FF).withValues(alpha: 0.7),
                  const Color(0xFF5A8BFF).withValues(alpha: 0.5),
                ],
                seed: 1,
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: CustomPaint(
              size: const Size(380, 360),
              painter: _BlobPainter(
                colors: [
                  const Color(0xFFFF6B9D).withValues(alpha: 0.6),
                  const Color(0xFFAB59FF).withValues(alpha: 0.5),
                ],
                seed: 2,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -60,
            child: CustomPaint(
              size: const Size(280, 300),
              painter: _BlobPainter(
                colors: [
                  const Color(0xFF00D4FF).withValues(alpha: 0.5),
                  const Color(0xFF9B59FF).withValues(alpha: 0.4),
                ],
                seed: 3,
              ),
            ),
          ),
          Positioned(
            bottom: 160,
            left: 40,
            child: CustomPaint(
              size: const Size(160, 160),
              painter: _BlobPainter(
                colors: [
                  const Color(0xFFFFD166).withValues(alpha: 0.5),
                  const Color(0xFFFF6B9D).withValues(alpha: 0.4),
                ],
                seed: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ING: Single blob painter with radial gradient and blur.
// PT: Pintor de mancha individual com gradiente radial e desfoque.
class _BlobPainter extends CustomPainter {
  final List<Color> colors;
  final int seed;

  const _BlobPainter({required this.colors, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    canvas.drawPath(_buildBlobPath(size, seed), paint);
  }

  Path _buildBlobPath(Size size, int seed) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    switch (seed) {
      case 1:
        path.moveTo(w * 0.50, h * 0.02);
        path.cubicTo(w * 0.80, h * -0.08, w * 1.10, h * 0.20, w * 0.92, h * 0.45);
        path.cubicTo(w * 0.78, h * 0.65, w * 0.95, h * 0.82, w * 0.65, h * 0.96);
        path.cubicTo(w * 0.35, h * 1.08, w * 0.10, h * 0.85, w * 0.08, h * 0.58);
        path.cubicTo(w * 0.05, h * 0.30, w * 0.20, h * 0.12, w * 0.50, h * 0.02);
        break;
      case 2:
        path.moveTo(w * 0.40, h * 0.05);
        path.cubicTo(w * 0.72, h * -0.03, w * 1.05, h * 0.12, w * 0.98, h * 0.38);
        path.cubicTo(w * 0.92, h * 0.60, w * 1.02, h * 0.80, w * 0.75, h * 0.92);
        path.cubicTo(w * 0.50, h * 1.03, w * 0.18, h * 0.95, w * 0.06, h * 0.70);
        path.cubicTo(w * -0.05, h * 0.45, w * 0.08, h * 0.14, w * 0.40, h * 0.05);
        break;
      case 3:
        path.moveTo(w * 0.55, h * 0.03);
        path.cubicTo(w * 0.85, h * 0.08, w * 1.00, h * 0.30, w * 0.90, h * 0.52);
        path.cubicTo(w * 0.82, h * 0.72, w * 0.90, h * 0.88, w * 0.60, h * 0.97);
        path.cubicTo(w * 0.30, h * 1.05, w * 0.08, h * 0.82, w * 0.12, h * 0.55);
        path.cubicTo(w * 0.15, h * 0.28, w * 0.25, h * -0.02, w * 0.55, h * 0.03);
        break;
      default:
        path.moveTo(w * 0.50, h * 0.05);
        path.cubicTo(w * 0.82, h * 0.00, w * 1.02, h * 0.25, w * 0.95, h * 0.50);
        path.cubicTo(w * 0.88, h * 0.75, w * 0.70, h * 1.00, w * 0.45, h * 0.98);
        path.cubicTo(w * 0.20, h * 0.95, w * -0.02, h * 0.72, w * 0.05, h * 0.48);
        path.cubicTo(w * 0.12, h * 0.22, w * 0.22, h * 0.10, w * 0.50, h * 0.05);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}