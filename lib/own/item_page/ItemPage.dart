

import 'package:demo/own/item_page/widget/ChildLineChartWidget.dart';
import 'package:demo/own/item_page/widget/ChildOnTimeLineChartWidget.dart';
import 'package:demo/own/item_page/widget/ChildOnTimeWidget.dart';
import 'package:demo/own/item_page/widget/ChildPieCharWidget.dart';
import 'package:demo/own/item_page/widget/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ItemPage extends StatefulWidget{
  String name;
  ItemPage({this.name});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(widget.name, style: TextStyle(color: Colors.black),),
      ),
      body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              HeaderWidget(name: widget.name),
            ];
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
                    ChildLineChartWidget(name: widget.name),
                    ChildPieChartWidget(name: widget.name,),
                    ChildOnTimeLineChartWidget(name: widget.name),
                    ChildOnTimePieChartWidget(name: widget.name),
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
