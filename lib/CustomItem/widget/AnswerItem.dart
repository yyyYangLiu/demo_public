import 'dart:convert';
import 'dart:io';
import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_color/random_color.dart';

class AnswerItem extends StatefulWidget{
  String name;
  String time;
  AnswerItem({this.name,this.time});

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
    setState(() {
      answerType = jsonDecode(contents)["type"];
      List<dynamic> dList = jsonDecode(contents)["answer"];
      answerList = dList.map((item) => item.toString()).toList();
    });
  }

  Widget answerBar(){
    if (answerType == "yes"){
      return YesAnswer(name: widget.name,time: widget.time,);
    }else if (answerType == "mul"){
      return MulAnswer(name: widget.name,time: widget.time, answerList: answerList,);
    }else if (answerType == "ent"){
      return EntAnswer(name: widget.name,time: widget.time,);
    }else{
      return Container(height: 10, color: Colors.transparent,);
    }
  }
  final db = CustomDatabaseHelper.instance;
  final searchdb = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {

    // define uniqueId
    String tableName;
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      tableName = response[0]["uniqueId"];

    });
    return RawMaterialButton(
      onPressed: (){
        db.show(widget.name);
        var table = db.queryAllRows(tableName);
        table.then((item){
          print(item);
        });
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
            // Time
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(widget.time.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),)),
            // Question
            Padding(
              padding: EdgeInsets.only(left: 10.0,top: 25.0),
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

// class for yes answer
class YesAnswer extends StatefulWidget{
  String name;
  String time;
  YesAnswer({this.name,this.time});

  @override
  _YesAnswerState createState() => _YesAnswerState();
}

class _YesAnswerState extends State<YesAnswer> with TickerProviderStateMixin{

  bool isSelecteYes = false;
  bool isSelecteNo = false;

  final db = CustomDatabaseHelper.instance;
  final searchdb = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {

    // define uniqueId
    String tableName;
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      tableName = response[0]["uniqueId"];

    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 250,
          child: Stack(
            children: <Widget>[
              AnimatedOpacity(
                opacity: isSelecteNo ? 0.0 : 1.0,
                duration: Duration(milliseconds: 50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn,
                    child: RawMaterialButton(
                      onPressed: (){
                        DateTime now = DateTime.now();
                        String currenttime = now.hour.toString() +":" + now.minute.toString();
                        Map<String, dynamic> row = new Map<String,dynamic>();
                        row["createyear"] = now.year.toString();
                        row["createmonth"] = now.month.toString();
                        row["createdate"] = now.day.toString();
                        row["createweek"] = now.weekday.toString();
                        row["createtime"] = widget.time;
                        row["answertime"] = currenttime;
                        row["answer"] = "yes";
                        db.insert(row, tableName);
                        // _animationController.forward();
                        setState(() {
                          isSelecteYes = true;
                        });
                      },
                      elevation: 2.0,
                      fillColor: Colors.red,
                      splashColor: Colors.transparent,
                      constraints: BoxConstraints(minHeight: 70,minWidth: isSelecteYes? 250 : 100),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Text("YES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),) ,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: isSelecteYes ? 0.0 : 1.0,
                duration: Duration(milliseconds: 50),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedSize(
                      vsync: this,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.fastOutSlowIn,
                      child: RawMaterialButton(
                        onPressed: (){
                          DateTime now = DateTime.now();
                          String currenttime = now.hour.toString() +":" + now.minute.toString();
                          Map<String, dynamic> row = new Map<String,dynamic>();
                          row["createyear"] = now.year.toString();
                          row["createmonth"] = now.month.toString();
                          row["createdate"] = now.day.toString();
                          row["createweek"] = now.weekday.toString();
                          row["createtime"] = widget.time;
                          row["answertime"] = currenttime;
                          row["answer"] = "no";
                          db.insert(row, tableName);
                          setState(() {
                            isSelecteNo = true;
                          });
                        },
                        elevation: 2.0,
                        fillColor: Colors.blue,
                        splashColor: Colors.transparent,
                        constraints: BoxConstraints(minHeight: 70,minWidth: isSelecteNo ? 250 : 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Text("NO",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}

// class for mul answer
class MulAnswer extends StatefulWidget{
  String name;
  String time;
  List<String> answerList;
  MulAnswer({this.name,this.time,this.answerList});

  @override
  _MulAnswerState createState() => _MulAnswerState();
}

class _MulAnswerState extends State<MulAnswer> with TickerProviderStateMixin{
  String selectedString = "";
  bool isSelected = false;

  final db = CustomDatabaseHelper.instance;
  final searchdb = DatabaseHelper.instance;

  Widget MulAnswerItem (text){
    RandomColor rdColor = RandomColor();
    // Color _color = rdColor.randomColor();

    // define uniqueId
    String tableName;
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      tableName = response[0]["uniqueId"];

    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: (){
          print("touch no $text");
          DateTime now = DateTime.now();
          String currenttime = now.hour.toString() +":" + now.minute.toString();
          Map<String, dynamic> row = new Map<String,dynamic>();
          row["createyear"] = now.year.toString();
          row["createmonth"] = now.month.toString();
          row["createdate"] = now.day.toString();
          row["createweek"] = now.weekday.toString();
          row["createtime"] = widget.time;
          row["answertime"] = currenttime;
          row["answer"] = text;
          db.insert(row, tableName);
          setState(() {
            isSelected = true;
            selectedString = text;
          });
        },
        elevation: 2.0,
        fillColor: Colors.red,
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
        child: Stack(
          children: <Widget>[
            AnimatedOpacity(
              opacity: isSelected ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: widget.answerList.map((text) => MulAnswerItem(text)).toList(),
              ),
            ),
            AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: Colors.blue,
                    height: 70,
                    width: isSelected ? 250 : 0,
                    child: Center(
                      child: Text(selectedString,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30.0),),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),);
  }
}

// class for ent answer
class EntAnswer extends StatefulWidget{
  String name;
  String time;
  EntAnswer({this.name,this.time});

  @override
  _EntAnswerState createState() => _EntAnswerState();
}

class _EntAnswerState extends State<EntAnswer> with TickerProviderStateMixin{
  TextEditingController enterController = new TextEditingController();
  String resultString = "";
  bool isSelected = false;

  final db = CustomDatabaseHelper.instance;
  final searchdb = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {

    // define uniqueId
    String tableName;
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      tableName = response[0]["uniqueId"];

    });

    return Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: <Widget>[
            AnimatedOpacity(
              opacity: isSelected ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: enterController,
                  autocorrect: true,
                  onSubmitted: (text){
                    print("touch no $text");
                    DateTime now = DateTime.now();
                    String currenttime = now.hour.toString() +":" + now.minute.toString();
                    Map<String, dynamic> row = new Map<String,dynamic>();
                    row["createyear"] = now.year.toString();
                    row["createmonth"] = now.month.toString();
                    row["createdate"] = now.day.toString();
                    row["createweek"] = now.weekday.toString();
                    row["createtime"] = widget.time;
                    row["answertime"] = currenttime;
                    row["answer"] = text;
                    db.insert(row, tableName);
                    setState(() {
                      resultString = text;
                      isSelected = true;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name : ",
                      hintText: 'Create a name'),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: Colors.blue,
                    height: 70,
                    width: isSelected ? 250 : 0,
                    child: Center(
                      child: Text(resultString,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

