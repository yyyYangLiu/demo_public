
import 'dart:convert';
import 'dart:io';

import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/own/item_page/widget/WidgetItem/LocalItem.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ChildLineChartWidgetMul extends StatefulWidget{
  String name;
  ChildLineChartWidgetMul({this.name});

  @override
  _ChildLineChartWidgetMulState createState() => _ChildLineChartWidgetMulState();
}

class _ChildLineChartWidgetMulState extends State<ChildLineChartWidgetMul> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;

  List answerList = new List();
  List<String> answerWidgetBackground = [];
  List<ItemValue> answerValue = [];

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
    setState(() {
      // get answerList
      List<dynamic> dList = jsonDecode(contents)["answer"];
      print("touch create answerList");
      answerList = dList.map((item) => item.toString()).toList();
      print(answerList);
    });
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
              print("touch in this one");
              double number = response.toDouble();
              double percentage = number / allresponse.toDouble();
              print(number);
              print(percentage);
              if (answerValue.length != answerList.length){
                if(mounted){
                  setState(() {
                    answerValue.add(ItemValue(count: number ,percentage: percentage,color: Colors.blue,name: i,));
                    answerWidgetBackground.add("background");
                  });
                }
              }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (answerValue.length == 0){
      print("outside of loadingData line mul");
      loadingData();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: (){},
        splashColor: Colors.transparent,
        fillColor: Colors.white,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: answerWidgetBackground.map((text) => LocalItem(type: text,)).toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: answerValue.map((object) => LocalItem(count: object.count,percentage: object.percentage,color: object.color,name: object.name,)).toList(),
              )
            ],
          ),
        ),
      ),
    );

  }
}

class ItemValue{
  double count;
  double percentage;
  Color color;
  String name;
  ItemValue({this.count,this.percentage,this.color,this.name});
}