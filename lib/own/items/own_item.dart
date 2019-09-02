
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:demo/dataBase/GPSDatabaseHelper.dart';
import 'package:demo/own/item_page/ItemPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_location/flutter_background_location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class MapTimeItem{
  String start;
  String end;
  MapTimeItem({this.start,this.end});
}

class OwnDataItem extends StatefulWidget{
  String name;
  Function delete;
  OwnDataItem({this.name,this.delete});

  @override
  OwnDataItemState createState() => OwnDataItemState();
}

class OwnDataItemState extends State<OwnDataItem> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation<double> _translateButton;

  bool isExist = true;
  bool isExist_C = true;

  String answerType = "";
  List<String> answerList = [];

  // (for the day widget)
  List<String> dayList = new List();
  // (for the day widget)
  List<int> listcount = new List();
  List<List<dynamic>> listTime = new List();

  // (for the map widget)
  List<MapTimeItem> maptimelist = new List();

  // using to the count buttom (in this page)
  int totalcount = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds:  300))
      ..addListener((){
        setState(() {});
      });
    _translateButton = Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
            0.0,
            0.75,
        )
    ));
    _initNote();
    _readFile();
    super.initState();
  }

  _initNote() async {
    var initializationSettingsAndroid = new AndroidInitializationSettings("app_icon");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid,initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectnotification);
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future onSelectnotification(String payload) async {
    showDialog(
        context: context,
        builder: (_){
          return new AlertDialog(
            title: Text("PayLoad"),
            content: Text("PayLoad : $payload"),
          );
        }
    );
  }


  final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

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
    print(contents);
    setState(() {
      // get Type
      answerType = jsonDecode(contents)["type"];
      // get answer
      List<dynamic> dList = jsonDecode(contents)["answer"];
      answerList = dList.map((item) => item.toString()).toList();
      // get day
      List<dynamic> switchdaylist = jsonDecode(contents)["day"];
      dayList = switchdaylist.map((item) => item.toString()).toList();
      // get day number count
      List<dynamic> switchNumberlist = jsonDecode(contents)["template"];
      List<dynamic> templateSelectList = jsonDecode(contents)["templateSelect"];
      listcount = new List();
      for (var index in templateSelectList){
          listcount.add(switchNumberlist.where((item) => item["index"].toString() == index.toString()).toList()[0]["time"].length);
      }
      // get the totalcount value
      listcount.forEach((item) => totalcount += item);
      // get details time list
      if (answerType == "map"){
        // set the map time list
        List timelist = new List();
        for (var index in templateSelectList){
          timelist.add(switchNumberlist.where((item) => item["index"].toString() == index.toString()).toList()[0]["time"]);
        }
        for (var i in timelist){
          var first = i[0].substring(10,15);
          var second = i[1].substring(10,15);
          maptimelist.add(MapTimeItem(start: first,end: second));
        }
      }else{
        // set the time list
        List timelist = new List();
        for (var index in templateSelectList){
          timelist.add(switchNumberlist.where((item) => item["index"].toString() == index.toString()).toList()[0]["time"]);
        }
        for (var i in timelist){
          List child = [];
          for (var j in i){
            String switchj = j.substring(10,15);
            child.add(switchj);
          }
          listTime.add(child);
        }
      }
    });
  }

  // init the remainder
  _setRemainder() async {
    String contents = await _readDatabase();
    // get time in today
    List<dynamic> switchNumberlist = jsonDecode(contents)["template"];
    List<dynamic> templateSelectList = jsonDecode(contents)["templateSelect"];

    var now = new DateTime.now();
    String todayWeekday = labels[now.weekday-1];
    int indexforTemplateSelect = dayList.indexOf(todayWeekday);
    int indexforTempalte = templateSelectList[indexforTemplateSelect];
    var list = switchNumberlist.where((item) => item["index"] == indexforTempalte).toList()[0]["time"];
    int id = 0;
    for (var timeString in list){
      String newtime = timeString.substring(10,15);
      Time time = new Time(int.parse(newtime.split(":")[0]),int.parse(newtime.split(":")[1]),0);
      _showDailyAtTime(id,time,newtime,widget.name);
      id ++;
    }
  }

  Future _showDailyAtTime(id,time,newtime,name) async {
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        name,
        newtime,
        time,
        platformChannelSpecifics);
  }


  _readlistfile () async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    var dir = new Directory('$path');
    List a = dir.listSync();
    for (var fileOrDir in a) {
      if (fileOrDir is File) {
        print("It is file");
        print(fileOrDir);
      } else if (fileOrDir is Directory) {
        print("it is dir");
        print(fileOrDir.path);
      }
    }
  }

  _deleteFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = await File('$path/${widget.name}.txt');
    try {
      file.delete();
    } catch(e) {}
  }


  _setLocation() async{
    final gpsdb = GPSDatabaseHelper.instance;
    FlutterBackgroundLocation.startLocationService();
    FlutterBackgroundLocation.getLocationUpdates((location) {
      var now = DateTime.now();
      String time = now.hour.toString()+":"+now.minute.toString();
      print(now.hour.toString()+":"+now.minute.toString());
      print(location.latitude.toString() + ","+location.longitude.toString());
      Map<String, dynamic> row = {
        "name" : widget.name,
        "time" : time,
        "latitude" : location.longitude,
        "longitude" : location.longitude
      };
      gpsdb.insert(row);
    });
  }



  bool isSelectRemainder = false;
  bool isRecordingGps = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isExist,
      child: Transform(
        transform: Matrix4.translationValues(_translateButton.value, 0.0 , 0.0),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: RawMaterialButton(
            onPressed: (){
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context){
                    return ItemPage(name: widget.name,);
                  }
              ));
            },
            splashColor: Colors.transparent,
            elevation: 4.0,
            constraints: BoxConstraints(minHeight: 200),
            fillColor: isExist_C ? Colors.white : Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: Container(
              child: Stack(
                children: <Widget>[
                  // Count Remainder
                  answerType != "map" ?
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 76,
                      child: Row(
                        children: <Widget>[
                          // set Remainder
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSelectRemainder = !isSelectRemainder;
                                  if (isSelectRemainder){
                                    _setRemainder();
                                  }else{
                                    flutterLocalNotificationsPlugin.cancelAll();
                                  }
                                });
                              },
                              child: Icon(Icons.alarm,color: isSelectRemainder ? Colors.blue : Colors.grey,)),
                          // show the total value
                          RawMaterialButton(
                            onPressed: (){},
                            fillColor: Colors.red,
                            constraints: BoxConstraints(minHeight: 30,minWidth: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(totalcount.toString(),style: TextStyle(color: Colors.white),),),
                        ],
                      ),
                    ),
                  ) :
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: (){
                            setState(() {
                              isRecordingGps = !isRecordingGps;
                              if (isRecordingGps){
                                _setLocation();
                              }else{
                                FlutterBackgroundLocation.stopLocationService();
                              }
                            });
                          },
                          child: Icon(Icons.location_searching,color: isRecordingGps ? Colors.red : Colors.grey,)),
                    ),
                  ),
                  // Close Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: RawMaterialButton(
                      constraints: BoxConstraints(minWidth: 30, minHeight: 30),
                      child: Icon(Icons.close,color: Colors.white,),
                      elevation: 2.0,
                      onPressed: () async {
                        _deleteFile();
                        setState(() {
                          isExist_C = false;
                        });
                        _animationController.forward();
                        await Future.delayed(Duration(milliseconds: 300));
                        setState(() {
                          isExist = false;
                        });
                        widget.delete(widget.name);
                      },
                      fillColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                    ),
                  ),
                  // Day Selector
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0,top: 50.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(widget.name,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0),)),
                      ),
                      Container(
                        child: dayBar(dayList: dayList,listcount: listcount, listtime: listTime, type: answerType,maptimelist: maptimelist,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class dayBar extends StatelessWidget{
  List<String> dayList;
  List<int> listcount;
  List<List<dynamic>> listtime;
  String type;
  List<MapTimeItem> maptimelist;
  dayBar({this.dayList,this.listcount,this.listtime,this.type,this.maptimelist});

  @override
  Widget build(BuildContext context) {

    if (type == "map"){
      List<Widget> MapDayList = new List();
      for (int i =0; i < dayList.length; i++){
        MapDayList.add(_MapDay(label: dayList[i],mtItem: maptimelist[i],));
      }
      return Padding(
        padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 5.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: MapDayList,
          ),
        ),
      );
    }else{
      List<Widget> DayList = new List();
      for (int i = 0; i < dayList.length;i++){
        // DayList.add(_Day(label: dayList[i], count: listcount[1]));
        DayList.add(_Day2(label: dayList[i],list: listtime[i],));
      }
      return Padding(
        padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 5.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: DayList,
          ),
        ),
      );
    }
  }
}

class _Day extends StatelessWidget {
  final String label;
  final int count;

  _Day({this.label,this.count});

  Widget ShowCountItem(){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: CustomPaint(painter: DrawCircle()),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> DayCount = new List();
    for (int i = 0; i < count; i ++){
      DayCount.add(ShowCountItem());
    }

    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Text(label,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: DayCount,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Day2 extends StatelessWidget{
  String label;
  List<dynamic> list;
  _Day2({this.label,this.list});

  Widget TextItem(i){
    return Text(i, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> DayTime = new List();
    for (var i in list){
      DayTime.add(TextItem(i));
    }
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(label,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: DayTime,
            ),
          )
        ],
      ),
    );
  }

}

class _MapDay extends StatelessWidget{
  final String label;
  final MapTimeItem mtItem;
  _MapDay({this.label,this.mtItem});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(label,style: TextStyle(color: Colors.black, fontWeight:  FontWeight.bold)),
          Text(mtItem.start, style:TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          Text(mtItem.end, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}

class DrawCircle extends CustomPainter {
  Paint _paint;

  DrawCircle() {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), 5.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
