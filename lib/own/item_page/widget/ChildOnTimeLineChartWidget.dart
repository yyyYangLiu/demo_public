

import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class ChildOnTimeLineChartWidget extends StatefulWidget{
  String name;
  ChildOnTimeLineChartWidget({this.name});

  @override
  _ChildOnTimeLineChartWidgetState createState() => _ChildOnTimeLineChartWidgetState();
}

class _ChildOnTimeLineChartWidgetState extends State<ChildOnTimeLineChartWidget> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;

  int onTime;
  double onTimePer = 0.0;
  int notonTime;
  double notonTimePer = 0.0;

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
      DateTime now = DateTime.now();
      var data = db.getTodayValues(tableName,now.year.toString(),now.month.toString(),now.day.toString());
      data.then((response){
        onTime = 0;
        notonTime = 0;
        for (var i in response){
          String createtime = i["createtime"];
          String answertime = i["answertime"];
          if (createtime == answertime){
            if (mounted) {
              setState(() {
                onTime ++;
                onTimePer = onTime / response.length;
              });
            }
          }else{
            if (mounted) {
              setState(() {
                notonTime ++;
                notonTimePer = notonTime / response.length;
              });
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("###############");
    print(onTime);
    print(onTimePer);
    print(notonTime);
    print(notonTimePer);
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
                    localItem(percentage: onTimePer,count: onTime,color: Colors.red,name: "On Time",),
                    localItem(percentage: notonTimePer,count: notonTime,color: Colors.blue,name: "Not on Time",),
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
  int count;
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
      double percentage = 0.0;
      if (widget.percentage < 0.05 && widget.percentage != 0){
        percentage = 0.05;
      }else if (widget.percentage > 0.95 && widget.percentage != 1){
        print("touch 0.95");
        percentage = 0.90;
      }else{
        percentage = widget.percentage;
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 300),
            child: Container(
              height: 50,
              width: widget.count != null ? 400 * percentage : 0,
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