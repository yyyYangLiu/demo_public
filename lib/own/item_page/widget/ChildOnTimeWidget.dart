

import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ChildOnTimePieChartWidget extends StatefulWidget {
  String name;
  ChildOnTimePieChartWidget({this.name});
  @override
  _childOnTimeWidgetState createState() => _childOnTimeWidgetState();
}

class _childOnTimeWidgetState extends State<ChildOnTimePieChartWidget> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;

  double onTime;
  double notonTime;

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
      var data = db.queryAllRows(tableName);
      data.then((response){
        onTime = 0;
        notonTime = 0;
        for (var i in response){
          String createtime = i["createtime"];
          String answertime = i["answertime"];
          if (createtime == answertime){
            setState(() {
              onTime ++;
            });
          }else{
            setState(() {
              notonTime ++;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (onTime != null && notonTime != null){
      Map<String, double> dataMap = new Map();
      dataMap.putIfAbsent("On Time", () => onTime);
      dataMap.putIfAbsent("Not on Time", () => notonTime);

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