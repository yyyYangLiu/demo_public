import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:demo/CustomItem/widget/AnswerItem.dart';
import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/dataBase/StoreModel/OwnDataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

class CustomDialogAnswerPage extends StatefulWidget{


  @override
  _CustomDialogAnswerPageState createState() => _CustomDialogAnswerPageState();
}

class _CustomDialogAnswerPageState extends State<CustomDialogAnswerPage> {
  final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  var currentPage;
  final dbHelper = DatabaseHelper.instance;
  final customdbHelper = CustomDatabaseHelper.instance;

  List<Widget> cardList = new List();
  List<OwnDataDataBase> list = new List();

  PageController controller;



  initState(){
    _loadData();
    _PageController();
    super.initState();
  }

  _PageController() async {
    controller = new PageController(initialPage: cardList.length - 1);
    controller.addListener((){
      setState(() {
        currentPage = controller.page;
      });
    });

  }

  _loadData() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) => list.add(OwnDataDataBase(id: row["_id"],name: row["name"])));
    for (OwnDataDataBase item in list) {
      _readTime(item.name);
    }
  }

  _readTime(name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = await File('$path/$name.txt');
    final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    String contents = await file.readAsString();

    // get day
    List<dynamic> switchdaylist = jsonDecode(contents)["day"];
    List<String> dayList = switchdaylist.map((item) => item.toString()).toList();
    // get day number count
    List<dynamic> switchNumberlist = jsonDecode(contents)["template"];
    List<dynamic> templateSelectList = jsonDecode(contents)["templateSelect"];

    var now = new DateTime.now();
    String todayWeekday = labels[now.weekday-1];
    int indexforTemplateSelect = dayList.indexOf(todayWeekday);
    int indexforTempalte = templateSelectList[indexforTemplateSelect];
    var alist = switchNumberlist.where((item) => item["index"] == indexforTempalte).toList()[0]["time"];
    for (var timeString in alist){
      String newtime = timeString.substring(10,15);
      var temptime = DateTime(now.year,now.month,now.day,int.parse(newtime.split(":")[0]),int.parse(newtime.split(":")[1]));
      // check time if before
      int checkDate = now.compareTo(temptime);


      var dbH = dbHelper.getData(name);
      dbH.then((response){
        String uniqueId = response[0]["uniqueId"];
        var dbC = customdbHelper.checkTime(newtime, uniqueId);
        dbC.then((response){
          bool check = response.length == 0;
          if (check){
            if (checkDate == 1){
              setState(() {
                cardList.add(AnswerItem(name: name,time: newtime,));
                currentPage = cardList.length.toDouble() - 1.0;
                Future.delayed(Duration(milliseconds: 100), () {
                  print("jump");
                  print(cardList.length - 1);
                  controller.jumpToPage(cardList.length - 1);
                });
              });
            }
          }
        });

      });
    }
  }




  @override
  Widget build(BuildContext context) {

    if (cardList.length != 0){

      return Container(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: PageView.builder(
              itemCount: cardList.length,
              controller: controller,
              reverse: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index){
                return Container();
            },)),
            CardScrollWidget(
                currentPage: currentPage,list: cardList),

          ],
        ),
      );
    }else{
      return SpinKitFadingFour(
        color: Colors.white,
        size: 50.0,

      );
    }
  }
}

var cardAspectRatio = 12.0/16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class CardScrollWidget extends StatefulWidget{
  var currentPage;
  List<Widget> list;

  CardScrollWidget({this.currentPage,this.list});

  @override
  CardScrollWidgetState createState() => CardScrollWidgetState();
}

class CardScrollWidgetState extends State<CardScrollWidget> {
  var padding = 40.0;
  var BottomPadding = 80.0;
  var verticalInset = 20.0;
  var BottomVerticalInset = 40.0;
  @override
  Widget build(BuildContext context) {
    List<Widget> locallist = new List();
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
          builder: (context,contraints){
            var width = contraints.maxWidth;
            var height = contraints.maxHeight;

            var safeWidth = width - 2 * padding;
            var safeHeight = height - 2 * padding;

            var heightOfPrimaryCard = safeHeight;
            var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

            var primaryCardLeft = safeWidth - widthOfPrimaryCard;
            var horizontalInset = primaryCardLeft / 2;

            for(var i = 0; i< widget.list.length; i++){
              var delta = i - widget.currentPage;
              bool isOnRight = delta > 0;

              var start = padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);

              var topbottom = padding + verticalInset * max(-delta,0.0);

              var top = max(padding + verticalInset * delta,0.0);

              var bottom = min(BottomPadding - BottomVerticalInset * delta,160.0);

              var cardItem = Positioned.directional(
                top: top,
                bottom: bottom,
                start: start,
                textDirection: TextDirection.rtl,
                child: widget.list[i],
              );
              locallist.add(cardItem);
            }
            return Stack(
              children: locallist,
            );
          }),);
  }
}

