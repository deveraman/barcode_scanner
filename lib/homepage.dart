import 'dart:io';

import 'package:barcode_scanner/barcodes_listener.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late MobileScannerController cameraController;
  late BarcodeListener barcodeListener;

  @override
  void initState() {
    super.initState();

    cameraController = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );

    barcodeListener = BarcodeListener();
  }

  @override
  void dispose() {
    cameraController.dispose();
    barcodeListener.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        actions: [
          IconButton(
            onPressed: () async {
              final temp = await getTemporaryDirectory();
              final barcodes = barcodeListener.capteredBarcodes.toList();
              String txt = '';

              for (final code in barcodes) {
                txt += '$code,';
              }

              final path = '${temp.path}/${DateTime.now()}.txt';

              await File(path).create();

              await File(path).writeAsString(txt);

              await Share.shareXFiles([XFile(path)]);
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                barcodeListener.setCapturedBarcodes = capture.barcodes;
              },
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: barcodeListener,
              builder: (context, child) {
                final barcodeList = barcodeListener.capteredBarcodes.toList();

                return ListView.builder(
                  itemCount: barcodeList.length,
                  itemBuilder: (context, index) => ListTile(
                    key: ValueKey(index),
                    title: Text(barcodeList[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
