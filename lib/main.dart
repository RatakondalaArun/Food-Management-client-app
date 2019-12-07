import 'package:flutter/material.dart';
import 'package:sqldemo/pages/details.dart';
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TabController _tabController;

  @override
  void initState() {
    // _tabController = TabController(length: 3);
    super.initState();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('GDS'),
          bottom: TabBar(
            isScrollable: false,
            // controller: _tabController,
            tabs: _tabs(),
          ),
        ),
        body: TabBarView(
          children: _body(),
        ),
      ),
    );
  }

  List<Widget> _tabs() {
    return <Widget>[
      Tab(
        icon: Icon(Icons.restaurant_menu),
      ),
      Tab(
        icon: Icon(Icons.camera_alt),
      ),
    ];
  }

  List<Widget> _body() {
    return <Widget>[
      Details(),
      QR(),
    ];
  }
}
