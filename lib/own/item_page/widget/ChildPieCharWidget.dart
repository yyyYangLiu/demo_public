

import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ChildPieChartWidget extends StatefulWidget{
  String name;
  ChildPieChartWidget({this.name});
  @override
  _ChildPieCharWidgetState createState() => _ChildPieCharWidgetState();
}

class _ChildPieCharWidgetState extends State<ChildPieChartWidget> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;

  double yes;
  double no;

  @override
  void initState() {
    loadingData();
    super.initState();
  }

  void loadingData () {
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      String tableName = response[0]["uniqueId"];
      print(tableName);

      DateTime now = DateTime.now();
      var countYes = db.queryRowCountByDateYes(tableName, now.year.toString(),now.month.toString(),now.day.toString());
      countYes.then((response){
        setState(() {
          yes = response.toDouble();
        });
      });

      // set no list
      var countNo = db.queryRowCountByDateNo(tableName, now.year.toString(),now.month.toString(),now.day.toString());
      countNo.then((response){
        setState(() {
          no = response.toDouble();
        });
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    if (yes != null && no != null){
      Map<String, double> dataMap = new Map();
      dataMap.putIfAbsent("Yes", () => yes);
      dataMap.putIfAbsent("No", () => no);

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RawMaterialButton(
          onPressed: (){},
          splashColor: Colors.transparent,
          elevation: 2.0,
          fillColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: PieChart(
            dataMap: dataMap,
            legendFontColor: Colors.blueGrey[900],
            legendFontSize: 14.0,
            legendFontWeight: FontWeight.w500,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery
                .of(context)
                .size
                .width / 2.7,
            showChartValuesInPercentage: true,
            showChartValues: true,
            chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
          ),
        ),
      );
    }else{
      return Container();
    }

  }
}