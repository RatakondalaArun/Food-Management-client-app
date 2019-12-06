import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqldemo/constants/constants.dart';

class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DetailsRender();
  }
}

class DetailsRender extends StatefulWidget {
  @override
  _DetailsRenderState createState() => _DetailsRenderState();
}

class _DetailsRenderState extends State<DetailsRender> {
  Widget _someThingWentWrong = Center(child: CircularProgressIndicator());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return _someThingWentWrong;
          print(snapshot.data.toString());
          return Center(
            child: Column(
              children: <Widget>[
                Text(snapshot.data[ResponseConstants.ID].toString()),
                Text(snapshot.data[ResponseConstants.LUNCH_DAY_1].toString()),
                Text(snapshot.data[ResponseConstants.LUNCH_DAY_2].toString()),
                Text(snapshot.data[ResponseConstants.REF_1_DAY_1].toString()),
                Text(snapshot.data[ResponseConstants.REF_1_DAY_2].toString()),
                Text(snapshot.data[ResponseConstants.REF_2_DAY_1].toString()),
                Text(snapshot.data[ResponseConstants.REF_2_DAY_2].toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future _getData() async {
    try {
      var url = DataBaseConstants.DATABASE_URL;
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);
      print(data);
      return data;
    } on FormatException {
      // try {
      //   setState(() {
      _someThingWentWrong = Center(
          child: Text(
        'Something Went Wrong!\n We are on it',
        textAlign: TextAlign.center,
      ));
      //   });
      // } catch (e) {
      //   print(e);
      // }
      print('formatexception in json object');
    }
  }
}
