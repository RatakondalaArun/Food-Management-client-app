import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqldemo/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqldemo/constants/error_codes.dart';
import 'package:toast/toast.dart';

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
  String _scanResultId = "Start Scanning by clicking that button";
  @override
  Widget build(BuildContext context) {
    //render page
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              Text(_scanResultId),
              _modes(),
            ],
          )),
        ),
      ),
    );
  }

  Widget _modes() {
    //render buttons
    return Column(
      children: <Widget>[
        _customButton(title: 'Day 1 Lunch', mode: ProcessConstants.LUNCH_DAY_1),
        _customButton(title: 'Day 2 Lunch', mode: ProcessConstants.LUNCH_DAY_2),
        _customButton(
            title: 'Day 1 Refreshment 1', mode: ProcessConstants.REF_1_DAY_1),
        _customButton(
            title: 'Day 1 Refreshment 2', mode: ProcessConstants.REF_1_DAY_2),
        _customButton(
            title: 'Day 2 Refreshment 1', mode: ProcessConstants.REF_2_DAY_1),
        _customButton(
            title: 'Day 2 Refreshment 2', mode: ProcessConstants.REF_2_DAY_2),
      ],
    );
  }

  Future _scanQr({String mode}) async {
    //scan qr when user clicks on it
    try {
      String result = await BarcodeScanner.scan();
      setState(() {
        this._scanResultId = result;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._scanResultId = 'Please enable camera permission';
        });
      } else {
        setState(() {
          _scanResultId = 'unknown $e';
        });
      }
    } on FormatException {
      setState(() {
        _scanResultId = 'Scanning Cancelled';
      });
    }
    _sendData(uid: this._scanResultId, mode: mode);
  }

  _sendData({String uid, String mode}) async {
    //send data uid and mode to server
    Map<String, dynamic> data = {
      'id': uid.toString(),
      'mode': mode.toString(),
    };
    print('sending data ${data.toString()}');
    try {
      var url = DataBaseConstants.DATABASE_PROCESS_URL;
      http.Response response = await http.post(url, body: data);
      print('site response code = ${response.statusCode}');
      if (response.statusCode == 200) {
        print(response.body);
        // print(jsonDecode(response.body[0]));
        Toast.show('${_validatingUserId(response.body.toString())}', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else if (response.statusCode == 500) {
        Toast.show('There is an error with server!', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {
        Toast.show('There is an unknown error occurred', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print('unable to send data! responsecode = ${response.statusCode}');
      }
    } on FormatException {
      //todo:user dialag
      print('formatexception in qr_reader.dart in _senddata function');
    } on SocketException {
      print('Socket Exception');
      Toast.show('Check your internet connection', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //socketException may occur if user changes
      // from wifi to mobile data while http request is ongoing
    }
  }

  String _validatingUserId(String code) {
    print(code);
    if (code.contains(ValidationErrors.ERR200)) return 'Updated successfully';
    if (code.contains(ValidationErrors.ERR380)) return 'Already collected';
    if (code.contains(ValidationErrors.ERR404_1)) return 'Invalid user';
    if (code.contains(ValidationErrors.ERR381)) return 'Already taken the food';
    if (code.contains(ValidationErrors.ERR382)) return 'Miscellaneous error';
    return 'unknown error occurred';
  }

  //----------------------------------------UI-REUSABLES-----------------------------
  //customButton for scanning codes
  Widget _customButton({
    String title,
    String mode,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        child: Text(title),
        onPressed: () => _scanQr(mode: mode),
      ),
    );
  }
}
