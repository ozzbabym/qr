import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image/image.dart' as img;
import 'utils/base64_checker.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  MobileScannerController cameraController = MobileScannerController();
  String? _scannedData;
  bool _isImage = false;

  void _handleBarcode(Barcode barcode) {
    if (barcode.rawValue == null) return;
    
    final data = barcode.rawValue!;
    final isBase64Image = Base64Checker.isBase64Image(data);
    
    setState(() {
      _scannedData = data;
      _isImage = isBase64Image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR to Image'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  _handleBarcode(barcodes.first);
                }
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildResultView(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    if (_scannedData == null) {
      return const Center(child: Text('Scan a QR code to see the result'));
    }

    if (_isImage) {
      return Center(
        child: Image.memory(
          base64Decode(_scannedData!),
          fit: BoxFit.contain,
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(_scannedData!),
      );
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
