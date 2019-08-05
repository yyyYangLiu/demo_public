

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OwnDataItem extends StatelessWidget{
  String name;
  OwnDataItem({this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            color: Colors.red,
            width: 1000,
            height: 150,
            child: Text(name),
          ),
        ),
      ),
    );
  }
}