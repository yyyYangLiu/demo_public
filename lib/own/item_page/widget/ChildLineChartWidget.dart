

import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class ChildLineChartWidget extends StatefulWidget{
  String name;
  ChildLineChartWidget({this.name});

  @override
  _ChildOnTimeLineChartWidgetState createState() => _ChildOnTimeLineChartWidgetState();
}

class _ChildOnTimeLineChartWidgetState extends State<ChildLineChartWidget> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;

  double yes;
  double yesPer = 0.0;
  double no;
  double noPer = 0.0;

  @override
  void initState() {
    loadingData();
    super.initState();
  }


  void loadingData () {
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      String tableName = response[0]["uniqueId"];
      print(tableName);
      var data = db.queryAllRows(tableName);
      data.then((totalresponse){
        List list = new List();
        for (var i in totalresponse){
          print(i);
          String datetime = i["createyear"].toString() +":"+i["createmonth"].toString()+":"+i["createdate"].toString();
          if (list.indexOf(datetime) == -1){
            list.add(datetime);
          }
        }

        // go over each element in the list
        for (var i in list){
          var stringlist = i.split(":");
          // set yes list
          var countYes = db.queryRowCountByDateYes(tableName, stringlist[2]);
          countYes.then((response){
            setState(() {
              yes = response.toDouble();
              yesPer = yes / totalresponse.length;
            });
          });

          // set no list
          var countNo = db.queryRowCountByDateNo(tableName, stringlist[2]);
          countNo.then((response){
            setState(() {
              no = response.toDouble();
              noPer = no /totalresponse.length;
            });
          });
        }

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: (){},
        splashColor: Colors.transparent,
        fillColor: Colors.white,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  localItem(type: "background",),
                  localItem(type: "background",),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  localItem(percentage: yesPer,count: yes,color: Colors.red,name: "Yes",),
                  localItem(percentage: noPer,count: no,color: Colors.blue,name: "No",),
                ],
              )
            ],
          ),
        ),
      ),
    );

  }
}

class localItem extends StatefulWidget{
  String name;
  String type;
  double percentage;
  double count;
  Color color;
  localItem({this.type,this.percentage,this.count,this.color,this.name});

  @override
  _localItemState createState() => _localItemState();
}

class _localItemState extends State<localItem> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    if (widget.type == "background"){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            height: 50,
            width: 400,
            color: Colors.grey[350],
          ),
        ),
      );
    }else{

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 300),
            child: Container(
              height: 50,
              width: widget.count != null ? 400 * widget.percentage : 0,
              color: widget.color,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(widget.count != null ? widget.count.toString() + " "+widget.name: "",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  )),
            ),
          ),
        ),
      );
    }
  }
}