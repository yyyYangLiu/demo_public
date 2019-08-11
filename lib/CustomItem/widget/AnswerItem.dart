


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_color/random_color.dart';

class AnswerItem extends StatefulWidget{
  String name;
  AnswerItem({this.name});

  @override
  _AnswerItemState createState() => _AnswerItemState();
}

class _AnswerItemState extends State<AnswerItem> {

  String answerType = "";
  List<String> answerList = [];

  TimeOfDay time = TimeOfDay.now();

  initState(){
    _readFile();
    super.initState();
  }

  _readFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = await File('$path/${widget.name}.txt');
    String contents = await file.readAsString();
    print(contents);
    setState(() {
      answerType = jsonDecode(contents)["type"];
      List<dynamic> dList = jsonDecode(contents)["answer"];
      answerList = dList.map((item) => item.toString()).toList();
    });
  }

  Widget answerBar(){
    if (answerType == "yes"){
      return YesAnswer();
    }else if (answerType == "mul"){
      return MulAnswer(answerList: answerList,);
    }else if (answerType == "ent"){
      return EntAnswer();
    }else{
      return Container(height: 10, color: Colors.transparent,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: (){
        print(answerList);
      },
      elevation: 4.0,
      fillColor: Colors.white,
      constraints: BoxConstraints(maxHeight: 200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: Container(
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Question
            Padding(
              padding: EdgeInsets.only(left: 10.0,top: 50.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(widget.name,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0),)),
            ),
            // Answer Bar
            Align(
                alignment: Alignment.bottomCenter,
                child: answerBar()),

          ],
        ),
      ),
    );
  }

}

class YesAnswer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RawMaterialButton(
                  onPressed: (){
                    print("touch yes");
                  },
                  elevation: 2.0,
                  fillColor: Colors.red,
                  constraints: BoxConstraints(minHeight: 70,minWidth: 100),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Text("YES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),) ,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RawMaterialButton(
                  onPressed: (){
                    print("touch no");
                  },
                  elevation: 2.0,
                  fillColor: Colors.blue,
                  constraints: BoxConstraints(minHeight: 70,minWidth: 100),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Text("NO",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}

class MulAnswer extends StatelessWidget{
  List<String> answerList;
  MulAnswer({this.answerList});

  Widget MulAnswerItem (text){
    RandomColor rdColor = RandomColor();
    Color _color = rdColor.randomColor();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: (){
          print("touch no");
        },
        elevation: 2.0,
        fillColor: _color,
        constraints: BoxConstraints(minHeight: 70,minWidth: 100),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Text(text,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: answerList.map((text) => MulAnswerItem(text)).toList(),
        ),
      ),);
  }
}

class EntAnswer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 10,
            color: Colors.black));
  }
}