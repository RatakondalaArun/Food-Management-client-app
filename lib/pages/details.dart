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
  void initState() {
    _getData();
    super.initState();
  }

  Future _getData() async {
    try {
      var url = DataBaseConstants.DATABASE_GET_URL;
      http.Response response = await http.get(
          url); //socketException may occur if user changes from wifi to mobile data while http request is ongoing
      var data = jsonDecode(response.body);
      return data;
    } on FormatException {
      _someThingWentWrong = Center(
          child: Text(
        'Something Went Wrong!\n We are on it',
        textAlign: TextAlign.center,
      ));
      print('formatexception in json object');
    }
  }

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
                _dataTable(
                  day1lunch:
                      snapshot.data[ResponseConstants.LUNCH_DAY_1].toString(),
                  day2launch:
                      snapshot.data[ResponseConstants.LUNCH_DAY_2].toString(),
                  day1ref1:
                      snapshot.data[ResponseConstants.REF_1_DAY_1].toString(),
                  day1ref2:
                      snapshot.data[ResponseConstants.REF_1_DAY_2].toString(),
                  day2ref1:
                      snapshot.data[ResponseConstants.REF_2_DAY_1].toString(),
                  day2ref2:
                      snapshot.data[ResponseConstants.REF_2_DAY_2].toString(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dataTable(
      {String day1lunch,
      String day2launch,
      String day1ref1,
      String day1ref2,
      String day2ref1,
      String day2ref2}) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(
                label: Row(
              children: <Widget>[
                Icon(Icons.restaurant_menu),
                Text('Menu'),
              ],
            )),
            DataColumn(
                label: Row(
              children: <Widget>[
                Icon(Icons.verified_user),
                Text('Status'),
              ],
            )),
          ],
          rows: <DataRow>[
            _buildRow(lable: 'Day 1 Lunch', status: day1lunch),
            _buildRow(lable: 'Day 2 Lunch', status: day2launch),
            _buildRow(lable: 'Day 1 Refershment 1', status: day1ref1),
            _buildRow(lable: 'Day 1 Refershment 2', status: day1ref2),
            _buildRow(lable: 'Day 2 Refershment 1', status: day2ref1),
            _buildRow(lable: 'Day 2 Refershment 2', status: day2ref2),
          ],
        ),
      ),
    );
  }

  // List<DataCell> _cells({
  //   String status,
  // }) {
  //   print(status);
  //   if (status == "1")
  //     status = "Not Avaliable";
  //   else
  //     status = "Avaliable";
  //   return <DataCell>[];
  // }

  DataRow _buildRow({
    String lable,
    String status,
  }) {
    print(status);
    if (status == "1")
      status = "Not Avaliable";
    else
      status = "Avaliable";
    return DataRow(cells: <DataCell>[
      DataCell(Text(lable)),
      DataCell(Text(status)),
    ]);
  }
}
