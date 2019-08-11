
import 'package:demo/dataBase/StoreModel/OwnDataModel.dart';
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

  void updateList(List<OwnDataDataBase> list){
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
          child: ListView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              OwnDataList(
                key: childkey,
              ),
              Container(
                height: 60,
                color: Colors.transparent,
              )
              //Safe Area
            ],
          )),

    );
  }
}