import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:sqldemo/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sqldemo/constants/error_codes.dart';

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
      appBar: AppBar(
          title: Text(
        'GDS',
        style: TextStyle(fontFamily: 'Quicksand'),
      )),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          padding: EdgeInsets.all(8),
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
      _sendData(uid: this._scanResultId, mode: mode);
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
  }

  _sendData({String uid, String mode}) async {
    _showToast(msg: 'Loading',icon: ICON.LOADING,bgColor: Colors.indigo);
    //send data uid and mode to server
    Map<String, dynamic> data = {
      'id': uid.toString(),
      'mode': mode.toString(),
    };
//    print('sending data ${data.toString()}');
    try {
      var url = DataBaseConstants.DATABASE_PROCESS_URL;
      http.Response response = await http.post(url, body: data);
//      print('site response code = ${response.statusCode}');
      if (response.statusCode == 200) {
//        print(response.body);
        _validatingUserId(response.body.toString());
        return;
      } else if (response.statusCode == 500) {
        _showToast(msg: 'There is an error with server!');
        return;
      } else {
        _showToast(msg: 'There is an unknown error occurred');
      }
    } on FormatException {
//      print('formatexception in qr_reader.dart in _senddata function');
    } on SocketException {
//      print('Socket Exception');
//      _showToast(msg: 'Check your internet connection');
      //socketException may occur if user changes
      // from wifi to mobile data while http request is ongoing
    }
  }

  _validatingUserId(String code) {
//    print(code);
    if (code.contains(ValidationErrors.ERR380)) {
      _showToast(
          msg: 'Updated successfull',
          icon: ICON.SUCCESS,
          bgColor: Colors.green);
      return;
    }
    if (code.contains(ValidationErrors.ERR381)) {
      _showToast(
          msg: 'Already collected',
          icon: ICON.WARNING,
          bgColor: Colors.redAccent);
      return;
    }
    if (code.contains(ValidationErrors.ERR404_1)) {
      _showToast(msg: 'Invalid user', icon: ICON.ERROR, bgColor: Colors.red);
      return;
    }
    if (code.contains(ValidationErrors.ERR382)) {
      _showToast(
          msg: 'Invalid error', icon: ICON.ERROR, bgColor: Colors.red);
      return;
    }
    _showToast(msg: 'unknown error occurred! please try again');
  }

  //----------------------------------------UI-REUSABLES-----------------------------
  //customButton for scanning codes
  Widget _customButton({
    String title,
    String mode,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 10,
        child: OutlineButton(
          child: Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () => _scanQr(mode: mode),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          splashColor: Colors.lightGreen.withOpacity(0.2),
          highlightedBorderColor: Colors.green,
          highlightColor: Colors.white.withOpacity(0),
        ),
      ),
    );
  }

  void _showToast(
      {@required String msg, Color bgColor, Color txtColor, ICON icon}) {
    FlutterFlexibleToast.showToast(
        message: msg,
        toastLength: Toast.LENGTH_LONG,
        toastGravity: ToastGravity.BOTTOM,
        icon: icon,
        radius: 20,
        elevation: 10,
        textColor: txtColor,
        backgroundColor: bgColor,
        timeInSeconds: 2);
  }
}
