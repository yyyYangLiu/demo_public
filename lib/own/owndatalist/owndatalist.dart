

import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/dataBase/StoreModel/OwnDataModel.dart';
import 'package:demo/own/items/own_item.dart';
import 'package:flutter/material.dart';

class OwnDataList extends StatefulWidget{
  final GlobalKey<OwnDataListState> key;
  OwnDataList({this.key});

  @override
  OwnDataListState createState() => OwnDataListState();
}

class OwnDataListState extends State<OwnDataList> {
  List<OwnDataDataBase> list = [];
  final dbHelper = DatabaseHelper.instance;
  List<Widget> DataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      allRows.forEach((row) => list.add(OwnDataDataBase(id: row["_id"],name: row["name"])));
      DataList.addAll(list.map((text) => OwnDataItem(name: text.name, delete: deleteOne,)).toList());
    });
  }

  void updateList(List<OwnDataDataBase> list){
    setState(() {
      DataList.addAll(list.map((text) => OwnDataItem(name: text.name,delete: deleteOne,)).toList());
    });
  }

  void deleteAll(){
    setState(() {
      DataList = [];
    });
  }

  void deleteOne(name){
    setState(() {
      dbHelper.delete(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: DataList,
    );
  }
}




