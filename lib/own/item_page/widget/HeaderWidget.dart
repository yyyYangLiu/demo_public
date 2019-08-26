

import 'dart:convert';
import 'dart:io';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_color/random_color.dart';

class HeaderWidget extends StatefulWidget{
  String name;
  String type;
  HeaderWidget({this.name,this.type});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.type == "yes"){
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: SampleChart(name: widget.name,),
        ),
      );
    }else if (widget.type == "mul"){
      return SliverToBoxAdapter(
        child: Container(
          height: 400,
          child: MulSampleChart(name: widget.name,),
        ),
      );
    }else if (widget.type == "ent"){
      return SliverToBoxAdapter(
        child: Container(
          height: 400,
          child: EnterChart(name: widget.name,),
        ),
      );
    }else{
      return SliverToBoxAdapter(child: Container());
    }
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
  DateTime fromDate;

  // count the number of yes
  double yes;
  double no;

  // List DatePoint in yes and no
  List<DataPoint<DateTime>> yesList = new List();
  List<DataPoint<DateTime>> noList = new List();

  // check
  var CountTotalWeek = new List();

  initState(){
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
      var data = db.queryAllRows(tableName);
      data.then((response){
        List list = new List();
        for (var i in response){
          String datetime = i["createyear"].toString() +":"+i["createmonth"].toString()+":"+i["createdate"].toString();
          if (list.indexOf(datetime) == -1){
            list.add(datetime);
          }
        }
        DateTime now = DateTime.now();
        // go over each element in the list
        for (var i in list){
          var stringlist = i.split(":");
          // set yes list
          var countYes = db.queryRowCountByDateYes(tableName, now.year.toString(),now.month.toString(),stringlist[2]);
          countYes.then((response){
            setState(() {
              yes = response.toDouble();
              yesList.add(DataPoint<DateTime>(value: yes, xAxis: DateTime(int.parse(stringlist[0]),int.parse(stringlist[1]),int.parse(stringlist[2]))));
            });
          });

          // set no list
          var countNo = db.queryRowCountByDateNo(tableName, now.year.toString(),now.month.toString(),stringlist[2]);
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
    // loading data
    if (yesList.length == 0 && noList.length == 0){
      loadingData();
    }
    if (fromDate != null && yesList.length != 0 && noList.length != 0){
      print("checking nowDate");
      final nowDate = DateTime.now();
      final toDate = DateTime.now().add(Duration(days:6));
      return Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: BezierChart(
          footerDateTimeBuilder: (DateTime value, BezierChartScale scaleType) {
            final newFormat = DateFormat('E dd');
            return newFormat.format(value);
          },
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.WEEKLY,
          toDate: toDate,
          selectedDate: nowDate,
          series: [
            BezierLine(
              label: "Total",
              onMissingValue: (dateTime){
                return CountTotalWeek[dateTime.weekday-1].toDouble();
              },
              data: [DataPoint<DateTime>(value:CountTotalWeek[fromDate.weekday-1].toDouble(), xAxis: fromDate)],
              lineColor: Colors.white,
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
              lineColor: Colors.white,
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
            snap: false,
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

class MulSampleChart extends StatefulWidget{
  String name;
  MulSampleChart({this.name});

  @override
  _MulSampleChartState createState() => _MulSampleChartState();
}

class _MulSampleChartState extends State<MulSampleChart> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;
  // create Date
  var fromDate;
  final toDate = DateTime.now();

  // all lines
  List<BezierLine> allLines = [];

  // check
  var CountTotalWeek = new List();

  //answer List
  List<String> answerList = [];

  //list list
  List<List<DataPoint<DateTime>>> allList = [];

  initState(){
    _readFile();
    getCreateDate();
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
      // get answerList
      List<dynamic> dList = jsonDecode(contents)["answer"];
      print("touch create answerList");
      answerList = dList.map((item) => item.toString()).toList();
      print(answerList);
      // get day number count
      List<dynamic> switchNumberlist = jsonDecode(contents)["template"];
      List<dynamic> templateSelectList = jsonDecode(contents)["templateSelect"];
      for (var index in templateSelectList){
        CountTotalWeek.add(switchNumberlist.where((item) => item["index"].toString() == index.toString()).toList()[0]["time"].length);
      }
    });
  }

  void getCreateDate () async {
    var getDate = await searchdb.getData(widget.name);
    print("getDate");
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
          String datetime = i["createyear"].toString() +":"+i["createmonth"].toString()+":"+i["createdate"].toString();
          if (list.indexOf(datetime) == -1){
            list.add(datetime);
          }
        }
        print("loadingData");
        print(CountTotalWeek);
        print("add first one");
        allLines.add(BezierLine(
          label: "Total",
          onMissingValue: (dateTimelocal){
            return CountTotalWeek[dateTimelocal.weekday-1].toDouble();
          },
          data: [DataPoint<DateTime>(value:CountTotalWeek[fromDate.weekday-1].toDouble(), xAxis: fromDate)],
          lineColor: Colors.white,
        ));

        print("sdf");
        print("##########");
        print(list);
        print(answerList);
        print(allList);

        // go over each element in the list
        for (var date in list){
          var stringlist = date.split(":");
          for ( var answer in answerList){
            var count = db.queryRowCountByDateValue(tableName, stringlist[2],answer);
            count.then((response){
              RandomColor rdColor = RandomColor();
              // colorHue: ColorHue.red
              // colorBrightness: ColorBrightness.light
              Color _color = rdColor.randomColor(colorSaturation: ColorSaturation.lowSaturation);
              setState(() {
                if (allList.length != answerList.length){
                  print(allList);
                  allList.add([DataPoint<DateTime>(value: response.toDouble(), xAxis: DateTime(int.parse(stringlist[0]),int.parse(stringlist[1]),int.parse(stringlist[2])))]);
                  allLines.add(BezierLine(
                      label: answer,
                      onMissingValue: (value){
                        return 0.0;
                      },
                      data: allList[answerList.indexOf(answer)],
                      lineColor: _color
                  ));
                }else{
                  allList[answerList.indexOf(answer)].add(DataPoint<DateTime>(value: response.toDouble(), xAxis: DateTime(int.parse(stringlist[0]),int.parse(stringlist[1]),int.parse(stringlist[2]))));
                }
              });
            });
          }
        }

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // loading data
    if (CountTotalWeek.length != 0 && answerList.length != 0){
      print(allLines.length);
      print(allLines.length == 0);
      if (allLines.length == 0){
        loadingData();
      }
    }
    if (fromDate != null && allLines.length != 0){
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
          series: allLines,
          config: BezierChartConfig(
            physics: BouncingScrollPhysics(),
            verticalIndicatorStrokeWidth: 2.0,
            verticalIndicatorColor: Colors.white,
            showVerticalIndicator: true,
            snap: false,
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

class EnterChart extends StatefulWidget{
  String name;
  EnterChart({this.name});

  @override
  _EnterChartState createState() => _EnterChartState();
}

class _EnterChartState extends State<EnterChart> {
  final searchdb = DatabaseHelper.instance;
  final db = CustomDatabaseHelper.instance;

  List<String> xAxis = [];
  List<String> answer = [];
  List<double> indexlist = [];

  void loadingData () {
    // find the uniqueId by name
    var getUniqueId = searchdb.getData(widget.name);
    getUniqueId.then((response){
      // get the uniqueId
      String tableName = response[0]["uniqueId"];
      DateTime now = DateTime.now();
      var data = db.getTodayValues(tableName, now.year.toString(), now.month.toString(), now.day.toString());
      data.then((response){
        var sortedresponse = response.toList()..sort((a,b) => int.parse(a["createtime"].replaceAll(RegExp(':'), '')).compareTo(int.parse(b["createtime"].replaceAll(RegExp(':'),''))));
        double index = 0;
        for (var i in sortedresponse){
          if (mounted){
            setState(() {
              print("inside");
              print(i);
              print(i["createtime"]);
              print(i["answer"]);
              xAxis.add(i["createtime"]);
              indexlist.add(index);
              answer.add(i["answer"]);
            });
          }
          index ++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (xAxis.length == 0 && answer.length == 0){
      loadingData();
    }
    print(xAxis);
    print(answer);
    if (xAxis.length != 0 && answer.length != 0){

      return Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: BezierChart(
          footerValueBuilder: (double){
            return xAxis[double.toInt()];
          },
          xAxisCustomValues: indexlist,
          bezierChartScale: BezierChartScale.CUSTOM,
          series: [
            BezierLine(
              label: "",
              data: answer.map((item) => DataPoint<double>(value: double.parse(item), xAxis: answer.indexOf(item).toDouble())).toList()
            )
          ],
          config: BezierChartConfig(
            physics: BouncingScrollPhysics(),
            verticalIndicatorStrokeWidth: 2.0,
            verticalIndicatorColor: Colors.white,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            contentWidth: MediaQuery.of(context).size.width *1.2,
            snap:false,
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