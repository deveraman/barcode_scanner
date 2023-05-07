import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeListener extends ChangeNotifier {
  final Set<String> _capturedBarcodes = {};

  Set<String> get capteredBarcodes => _capturedBarcodes;

  set setCapturedBarcodes(List<Barcode> barcodes) {
    final decodedBarcodes = barcodes.map((e) => e.rawValue).toList();

    final removeNulls =
        decodedBarcodes.where((e) => (e != null && e.isNotEmpty)).toList();

    final list = removeNulls.map((b) => b!).toList();

    _capturedBarcodes.addAll(list.toSet());

    notifyListeners();
  }

  @override
  void dispose() {
    _capturedBarcodes.clear();
    super.dispose();
  }
}
