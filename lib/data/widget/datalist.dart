

import 'package:demo/data/items/data_item.dart';
import 'package:flutter/material.dart';

class DataList extends StatefulWidget{

  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  List<Widget> _DataList = [];

  @override
  void initState() {
    for (var i =0; i < 20; i++){
      _DataList.add(DataItem());
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverToBoxAdapter(
      child: Column(
        children: _DataList,
      ),
    );
  }
}