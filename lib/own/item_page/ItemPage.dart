

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class ItemPage extends StatefulWidget{
  String name;
  ItemPage({this.name});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = new AndroidInitializationSettings("app_icon");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid,initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectnotification);
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

  @override
  Widget build(BuildContext context) {

    List<Widget> checkList = new List();

    for (int i =0; i <10; i ++){
      checkList.add(ChildCoverItem(child: Text(i.toString())));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text(widget.name,style: TextStyle(color: Colors.black),),
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  height: 250,
                  color: Colors.transparent,
                ),
              )
            ];
          },
          body: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
            child: Container(
              color: Colors.white,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll){
                  overscroll.disallowGlow();
                },
                child: ListView(
                  children: <Widget>[
                    ChildCoverItem(
                      child: Text("Show Time (schedule)"),
                      onPressed: _checkTime,
                    ),
                    ChildCoverItem(
                      child: Text("Show Time"),
                      onPressed: _showDailyAtTime,
                    ),
                    ChildCoverItem(
                      child: Text("Show Notification Without Soun"),
                      onPressed: _showNotificationWithoutSound,
                    ),
                    ChildCoverItem(
                      child: Text("Show Notification With Default Sound"),
                      onPressed: _showNotificationWithDefaultSound,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future _checkTime () async {
    var scheduledNotificationDateTime =
    new DateTime.now().add(new Duration(seconds: 5));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails("002", "your channel name", "your channel description", importance: Importance.Max,priority: Priority.High);
    var iosPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        4,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: "Schedule");
  }

  Future _showDailyAtTime() async {
    var time = new Time(18, 40, 0);
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately',
        time,
        platformChannelSpecifics);
  }

  Future _showNotificationWithDefaultSound() async {
    print("get into second");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails("002", "your channel name", "your channel description", importance: Importance.Max,priority: Priority.High);
    var iosPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0,'New Post','How to Show Notification in Flutter',platformChannelSpecifics,payload: 'Custom_Sound');

  }

  Future _showNotificationWithoutSound() async {
    print("get into thrid");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails("003", "your channel name", "your channel description",playSound: false,importance: Importance.Max,priority: Priority.High);
    var iosPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(1, "New Post", "How to Show Notification in Flutter", platformChannelSpecifics,payload: "No_Sound");
  }
}


class ChildCoverItem extends StatelessWidget{
  Widget child;
  Function onPressed;
  ChildCoverItem({this.child,this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: (){
          print("touch");
          onPressed();
        },
        elevation: 2.0,
        fillColor: Colors.white,
        constraints: BoxConstraints(minHeight: 200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: <Widget>[
            child
          ],
        ),
      ),
    );
  }
}