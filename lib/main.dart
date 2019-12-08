import 'package:flutter/material.dart';
import 'package:sqldemo/pages/qr_reader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDS',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: TextTheme(
            button: TextStyle(fontFamily: 'Quicksand'),
            title: TextStyle(fontFamily: 'Quicksand')),
      ),
      home: QR(),
    );
  }
}