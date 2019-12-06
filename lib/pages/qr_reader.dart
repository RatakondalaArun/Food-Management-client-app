import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Reader();
  }
}

class Reader extends StatefulWidget {
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  String _scanResult = "Start Scanning by clicking that button";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text(_scanResult)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text('scan'),
        onPressed: () => _scanQr(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future _scanQr() async {
    try {
      String result = await BarcodeScanner.scan();
      setState(() {
        this._scanResult = result;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._scanResult = 'Please enable camera permission';
        });
      } else {
        setState(() {
          _scanResult = 'unknown $e';
        });
      }
    } on FormatException {
      setState(() {
        _scanResult = 'Scanning Cancelled';
      });
    }
  }
}
