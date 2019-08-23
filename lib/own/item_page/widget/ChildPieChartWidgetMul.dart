
import 'dart:convert';
import 'dart:io';

import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class ChildPieChartWidgetMul extends StatefulWidget{
  String name;
  ChildPieChartWidgetMul({this.name});

  @override
  _ChildPieChartWidgetMulState createState() => _ChildPieChartWidgetMulState();
}

class _ChildPieChartWidgetMulState extends State<ChildPieChartWidgetMul> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;

  List answerList = new List();

  Map<String, double> dataMap = new Map();



  @override
  void initState() {
    _readFile();
    super.initState();
  }

  _readDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = await File('$path/${widget.name}.txt');
    String contents = await file.readAsString();
    return contents;
  }

  // for init value in the card
  _readFile() async {
    String contents = await _readDatabase();
    if (mounted){
      setState(() {
        // get answerList
        List<dynamic> dList = jsonDecode(contents)["answer"];
        print("touch create answerList");
        answerList = dList.map((item) => item.toString()).toList();
        print(answerList);
      });
    }

  }

  void loadingData () {
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      String tableName = response[0]["uniqueId"];
      print(tableName);
      DateTime now = DateTime.now();
      var allList = db.queryRowCountByDate(tableName, now.day.toString());
      allList.then((allresponse){
        for (var i in answerList){
          var data = db.queryRowCountByDateValue(tableName,now.day.toString(),i);
          data.then((response){
            if (mounted){
              setState(() {
                print("touch in this one");
                double number = response.toDouble();
                if (dataMap.length != answerList.length){
                  dataMap.putIfAbsent(i, () => number);
                }
              });
            }
          });
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    if (dataMap.length == 0){
      loadingData();
    }
    if (dataMap.length != 0){
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