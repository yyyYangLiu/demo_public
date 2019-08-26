
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ShowTime extends StatefulWidget{
  String name;
  ShowTime({this.name});

  @override
  _ShowTimeState createState() => _ShowTimeState();
}

class _ShowTimeState extends State<ShowTime> {

  String answerType;
  List<String> answerList;
  List<String> dayList;
  List listcount;
  var totalcount;

  initState(){
    // _readFile();
    super.initState();
  }

  _readDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = await File('$path/${widget.name}.txt');
    String contents = await file.readAsString();
    return contents;
  }

  _readFile() async {
    String contents = await _readDatabase();
    print(contents);
    setState(() {
      // get Type
      answerType = jsonDecode(contents)["type"];
      // get answer
      List<dynamic> dList = jsonDecode(contents)["answer"];
      answerList = dList.map((item) => item.toString()).toList();
      // get day
      List<dynamic> switchdaylist = jsonDecode(contents)["day"];
      dayList = switchdaylist.map((item) => item.toString()).toList();
      // get day number count
      List<dynamic> switchNumberlist = jsonDecode(contents)["template"];
      List<dynamic> templateSelectList = jsonDecode(contents)["templateSelect"];
      listcount = new List();
      for (var index in templateSelectList){
        listcount.add(switchNumberlist.where((item) => item["index"].toString() == index.toString()).toList()[0]["time"].length);
      }
      // get the totalcount value
      listcount.forEach((item) => totalcount += item);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: GestureDetector(
            onTap: (){

            },
            child: Icon(Icons.update)));
  }
}