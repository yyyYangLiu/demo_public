

import 'package:demo/own/items/own_item.dart';
import 'package:flutter/material.dart';

class OwnDataList extends StatefulWidget{

  @override
  _OwnDataListState createState() => _OwnDataListState();
}

class _OwnDataListState extends State<OwnDataList> {
  List<Widget> _DataList = [];

  @override
  void initState() {
    for (var i =0; i < 20; i++){
      _DataList.add(OwnDataItem());
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



