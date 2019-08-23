

import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/own/item_page/widget/WidgetItem/LocalItem.dart';
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
      DateTime now = DateTime.now();
      var total = db.getTodayValues(tableName, now.year.toString(), now.month.toString(), now.day.toString());
      total.then((totalcount){
        var countYes = db.queryRowCountByDateYes(tableName, now.year.toString(),now.month.toString(),now.day.toString());
        countYes.then((response){
          print("yes");
          print(response);
          setState(() {
            yes = response.toDouble();
            if (totalcount.length != 0){
              yesPer = yes / totalcount.length.toDouble() ;
            }

          });
        });

        // set no list
        var countNo = db.queryRowCountByDateNo(tableName, now.year.toString(),now.month.toString(),now.day.toString());
        countNo.then((response){
          setState(() {
            no = response.toDouble();
            if (totalcount.length != 0){
              noPer = no /totalcount.length.toDouble() ;
            }

          });
        });
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
                    LocalItem(type: "background",),
                    LocalItem(type: "background",),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LocalItem(percentage: yesPer,count: yes,color: Colors.red,name: "Yes",),
                    LocalItem(percentage: noPer,count: no,color: Colors.blue,name: "No",),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  }
}

