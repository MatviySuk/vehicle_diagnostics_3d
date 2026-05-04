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
        appBar: AppBar(
          title: const Text('Scan QR Code'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _closeScanner,
          ),
        ),
        body: Stack(
          children: [
            MobileScanner(controller: _scannerController, onDetect: _onQrDetected),
            if (_isLoading)
              const ColoredBox(
                color: Colors.black38,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Vehicle Diagnostics 3D',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              const Text('Sign in to continue.'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _openScanner,
                child: const Text('Sign in with QR Code'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _isLoading ? null : _generateNewSession,
                child: _isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Create new session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}