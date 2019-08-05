

import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/own/items/own_item.dart';
import 'package:flutter/material.dart';

class OwnDataList extends StatefulWidget{
  final GlobalKey<OwnDataListState> key;
  OwnDataList({this.key});

  @override
  OwnDataListState createState() => OwnDataListState();
}

class OwnDataListState extends State<OwnDataList> {
  List<String> list = [];
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
      allRows.forEach((row) => list.add(row.toString()));
      DataList.addAll(list.map((text) => OwnDataItem(name: text,)).toList());
    });
    print("touch load data");
    print(list);
  }

  void updateList(List<String> list){
    print("get in second key");
    setState(() {
      DataList.addAll(list.map((text) => OwnDataItem(name: text)).toList());
      print(DataList);
    });
  }

  void deleteAll(){
    print("touch");
    setState(() {
      DataList = [];
    });
  }


  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: DataList,
      ),
    );
  }
}




