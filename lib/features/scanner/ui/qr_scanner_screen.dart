import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Component QR')),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            final rawValue = barcodes.first.rawValue!;
            
            // Expected format: PART_ID:HEADLIGHT_LEFT
            if (rawValue.startsWith('PART_ID:')) {
              final componentId = rawValue.split(':')[1];
              // Stop scanning to prevent multiple triggers
              controller.stop();
              
              // Return to dashboard and pass the scanned component
              context.pop(componentId);
            }
          }
        },
      ),
    );
  }
}
