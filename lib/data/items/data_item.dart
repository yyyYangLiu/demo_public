

import 'package:demo/data/child_page/datadetailspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataItem extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(CupertinoPageRoute(

          builder: (BuildContext context){
            return DataDetailsPage();
          }
        ));
      },
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            color: Colors.blue,
            width: 1000,
            height: 150,
          ),
        ),
      ),
    );
  }
}