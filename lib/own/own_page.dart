

import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/home/home_page.dart';
import 'package:demo/own/owndatalist/owndatalist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OwnPage extends StatefulWidget{
  GlobalKey<OwnPageState> key;
  OwnPage({this.key});

  @override
  OwnPageState createState() => OwnPageState();
}

class OwnPageState extends State<OwnPage> {

  GlobalKey<OwnDataListState> childkey = GlobalKey();

  void updateList(List<String> list){
    print("get in first key");
    childkey.currentState.updateList(list);
  }

  void deleteAll(){
    childkey.currentState.deleteAll();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              OwnDataList(
                key: childkey,
              )
            ],
          )),

    );
  }
}