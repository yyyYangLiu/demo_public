
import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class ChildTimeListWidget extends StatefulWidget{
  String name;
  ChildTimeListWidget({this.name});

  @override
  _ChildTimeListWidgetState createState() => _ChildTimeListWidgetState();
}

class _ChildTimeListWidgetState extends State<ChildTimeListWidget> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;

  List<Widget> list = [];

  @override
  void initState() {
    loadingData();
    super.initState();
  }

  void loadingData () {
    // find the uniqueId by name
    DateTime now = DateTime.now();
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      String tableName = response[0]["uniqueId"];
      print(tableName);
      var data = db.getTodayValues(tableName,now.year.toString(),now.month.toString(),now.day.toString());
      data.then((response){
        var sortedresponse = response.toList()..sort((a,b) => int.parse(a["createtime"].replaceAll(RegExp(':'), '')).compareTo(int.parse(b["createtime"].replaceAll(RegExp(':'),''))));
        for (var i in sortedresponse){
          setState(() {
            list.add(TimeListItem(i["createtime"],i["answertime"],i["answer"]));
          });
        }
      });
    });
  }

  Widget TimeListItem(String time,String answertime,String answer){
    int hours = int.parse(time.split(":")[0]);
    int second = int.parse(time.split(":")[1]);

    int answerhours = int.parse(answertime.split(":")[0]);
    int answermin = int.parse(answertime.split(":")[1]);

    bool isSameTime = hours == answerhours && second == answermin;

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(time,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 32.0),),
          //Text(isSameTime ? "On Time" : "Not on Time",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 32.0)),
          Text(answer,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 32.0),)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(left: 10.0,right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
        child: Container(
          color: Colors.blue,
          child: Column(
            children: list,
          ),
        ),
      ),
    );
  }
}