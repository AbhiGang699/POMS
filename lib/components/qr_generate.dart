import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({Key? key, required this.data, required this.display})
      : super(key: key);
  final String data;
  final String display;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generated QR")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                display,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16)),
          Center(
            child: QrImage(
              data: data,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ],
      ),
    );
  }
}
