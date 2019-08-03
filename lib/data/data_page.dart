import 'package:demo/data/floating_page/addOrsearchPage.dart';
import 'package:demo/data/items/data_item.dart';
import 'package:demo/data/widget/datalist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataPage extends StatefulWidget{

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            DataList(),
          ],
        ),
      ),
    );
  }
}