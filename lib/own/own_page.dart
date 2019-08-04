

import 'package:demo/own/owndatalist/owndatalist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OwnPage extends StatefulWidget{

  @override
  _OwnPageState createState() => _OwnPageState();
}

class _OwnPageState extends State<OwnPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              OwnDataList()
            ],
          )),

    );
  }
}