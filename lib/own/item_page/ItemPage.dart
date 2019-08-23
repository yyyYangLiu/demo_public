

import 'dart:convert';
import 'dart:io';

import 'package:demo/own/item_page/widget/ChildLineChartWidget.dart';
import 'package:demo/own/item_page/widget/ChildLineChartWidgetMul.dart';
import 'package:demo/own/item_page/widget/ChildOnTimeLineChartWidget.dart';
import 'package:demo/own/item_page/widget/ChildOnTimeWidget.dart';
import 'package:demo/own/item_page/widget/ChildPieCharWidget.dart';
import 'package:demo/own/item_page/widget/ChildPieChartWidgetMul.dart';
import 'package:demo/own/item_page/widget/ChildTimeListWidget.dart';
import 'package:demo/own/item_page/widget/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
class ItemPage extends StatefulWidget{
  String name;
  ItemPage({this.name});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String type;

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
      type = jsonDecode(contents)["type"];
      print(type);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        backgroundColor: Colors.red,
        brightness: Brightness.light,
        title: Text(widget.name, style: TextStyle(color: Colors.white),),
      ),
      body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            if (type != null){
              return <Widget>[
                HeaderWidget(name: widget.name,type: type,),
              ];
            }
            return <Widget>[];
          },
          body: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            child: Container(
              color: Colors.white,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    ChildTimeListWidget(name: widget.name),
                    type == "yes" ? ChildLineChartWidget(name: widget.name) : Container() ,
                    type == "yes" ? ChildPieChartWidget(name: widget.name,) : Container() ,
                    type == "yes" ? ChildOnTimeLineChartWidget(name: widget.name) : Container() ,
                    type == "yes" ? ChildOnTimePieChartWidget(name: widget.name) : Container(),
                    // type == "mul" ? ChildLineChartWidgetMul(name: widget.name) : Container(),
                    type == "mul" ? ChildPieChartWidgetMul(name: widget.name) : Container(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
