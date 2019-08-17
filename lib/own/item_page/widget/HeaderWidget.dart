

import 'dart:convert';
import 'dart:io';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class HeaderWidget extends StatefulWidget{
  String name;
  HeaderWidget({this.name});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        child: SampleChart(name: widget.name,),
      ),
    );
  }

}

class SampleChart extends StatefulWidget{
  String name;
  SampleChart({this.name});
  @override
  _SampleChartState createState() => _SampleChartState();
}

class _SampleChartState extends State<SampleChart> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;
  // create Date
  var fromDate;
  final toDate = DateTime.now();

  // count the number of yes
  double yes;
  double no;

  // List DatePoint in yes and no
  List<DataPoint<DateTime>> yesList = new List();
  List<DataPoint<DateTime>> noList = new List();

  // check
  var CountTotalWeek = new List();

  initState(){
    loadingData();
    getCreateDate();
    _readFile();
    super.initState();
  }

  _readDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = await File('$path/${widget.name}.txt');
    String contents = await file.readAsString();
    return contents;
  }

  // for init value in the card
  _readFile() async {
    String contents = await _readDatabase();
    setState(() {
      // get day number count
      List<dynamic> switchNumberlist = jsonDecode(contents)["template"];
      List<dynamic> templateSelectList = jsonDecode(contents)["templateSelect"];
      for (var index in templateSelectList){
        CountTotalWeek.add(switchNumberlist.where((item) => item["index"].toString() == index.toString()).toList()[0]["time"].length);
      }
      print(CountTotalWeek);

    });
  }

  void getCreateDate () async {
    var getDate = await searchdb.getData(widget.name);
    print(getDate);
    String createDate = getDate[0]["createDate"];
    print(createDate);
    List<String> createDateList = createDate.split(":");
    setState(() {
      fromDate = DateTime(int.parse(createDateList[0]),int.parse(createDateList[1]),int.parse(createDateList[2]));
    });
  }

  void loadingData () {
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      String tableName = response[0]["uniqueId"];
      print(tableName);
      var data = db.queryAllRows(tableName);
      data.then((response){
        List list = new List();
        for (var i in response){
          print(i);
          String datetime = i["createyear"].toString() +":"+i["createmonth"].toString()+":"+i["createdate"].toString();
          if (list.indexOf(datetime) == -1){
            list.add(datetime);
          }
        }
        print(list);

        // go over each element in the list
        for (var i in list){
          var stringlist = i.split(":");
          // set yes list
          var countYes = db.queryRowCountByDateYes(tableName, stringlist[2]);
          countYes.then((response){
            setState(() {
              yes = response.toDouble();
              yesList.add(DataPoint<DateTime>(value: yes, xAxis: DateTime(int.parse(stringlist[0]),int.parse(stringlist[1]),int.parse(stringlist[2]))));
            });
          });

          // set no list
          var countNo = db.queryRowCountByDateNo(tableName, stringlist[2]);
          countNo.then((response){
            setState(() {
              no = response.toDouble();
              noList.add(DataPoint<DateTime>(value: no, xAxis: DateTime(int.parse(stringlist[0]),int.parse(stringlist[1]),int.parse(stringlist[2]))));
            });
          });
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("get into build function");
    print(yesList);
    print(noList);
    if (fromDate != null && yesList.length != 0 && noList.length != 0){
      return Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: BezierChart(
          footerDateTimeBuilder: (DateTime value, BezierChartScale scaleType) {
            final newFormat = DateFormat('E dd');
            return newFormat.format(value);
          },
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.WEEKLY,
          toDate: DateTime.now().add(Duration(days: 6)),
          selectedDate: DateTime.now(),
          series: [
            BezierLine(
              label: "Total",
              onMissingValue: (dateTime){
                return CountTotalWeek[dateTime.weekday-1].toDouble();
              },
              data: [DataPoint<DateTime>(value:CountTotalWeek[fromDate.weekday-1].toDouble(), xAxis: fromDate)],
              lineColor: Colors.grey,
            ),
            // yes line
            BezierLine(
              label: "Yes",
              onMissingValue: (dateTime) {
                return 0.0;
              },
              data: yesList,
            ),
            // no line
            BezierLine(
              label: "No",
              lineColor: Colors.lightGreenAccent,
              onMissingValue: (dateTime){
                return 0.0;
              },
              data: noList
            )
          ],
          config: BezierChartConfig(
            physics: BouncingScrollPhysics(),
            verticalIndicatorStrokeWidth: 2.0,
            verticalIndicatorColor: Colors.grey,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundColor: Colors.red,
            footerHeight: 30.0,
          ),
        ),
      );
    }else{
      return Container();
    }
  }
}

