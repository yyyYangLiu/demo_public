

import 'dart:convert';
import 'dart:io';

import 'package:demo/AnswerPage/AnswerDialog.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/own/floating_page/PersonalDataPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FancyFab extends StatefulWidget{
  final Function onPressed;
  final Function onDelete;
  final TabController tabController;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed,this.onDelete,this.tooltip,this.icon, this.tabController});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab> with SingleTickerProviderStateMixin{

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _febHeight = 56.0;

  TextEditingController enterController = new TextEditingController();

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds:  500))
            ..addListener((){
              setState(() {});
            });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear
      ),
    ));
    _translateButton = Tween<double>(
      begin: _febHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve
      )
    ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate(){
    if(!isOpened){
      _animationController.forward();
    } else{
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  _showDialog() async {
    await showDialog<String>(
        context: context,
        child: new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: new TextField(
                    controller: enterController,
                    autocorrect: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Name : ",
                        hintText: 'Create a name'),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Flexible(
                  child: RawMaterialButton(
                    fillColor: Colors.blue,
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (BuildContext context){
                            return PersonalDataPage(name: enterController.text, updateMainPage: widget.onPressed,);
                          }
                      ));
                    },
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Create",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Widget add(index){
    return new Container(
      width: 65,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              heroTag: "add",
              onPressed: (){
                if (index == 1){
                  _showDialog();
                }else{
                  print("get into check");
                }
              },
              tooltip: 'Add',
              child: Icon(Icons.add),
            ),
          )
        ],
      )
    );
  }

  Widget inbox(){
    return new Container(
      child: FloatingActionButton(
        heroTag: "inbox",
        onPressed: widget.onDelete,
        tooltip: 'Inbox',
        child: Icon(Icons.inbox),
      ),
    );
  }

  // using to check the number of card
  final dbHelper = DatabaseHelper.instance;
  List<String> timeList = new List();
  int count = 0;

  // loading the data in the database
  _loadData() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) =>  _readTime(row["name"]));
  }

  // check the time meet the requirement
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
      // unique
      var uniqueNum = name+newtime;
      if (checkDate == 1){
        if (timeList.indexOf(uniqueNum) == -1){
          timeList.add(uniqueNum);
        }
      }
    }
  }

  Widget answer(){

    _loadData();
    setState(() {
      count = timeList.length;
    });

    return Container(
      height: 65,
      width: 65,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              heroTag: "answer",
              onPressed: (){
                AnswerDialog(context);
              },
              child: Icon(Icons.alarm),),
          ),
          Positioned(
            right: 0,
            child: new Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(
                minWidth: 25,
                minHeight: 25,
              ),
              child: Center(
                child: new Text(
                  count.toString(),
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget toggle(){
    return FloatingActionButton(
      heroTag: "toggle",
      backgroundColor: _animateColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    if (widget.tabController.index == 0){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform(
              transform: Matrix4.translationValues(0.0, _translateButton.value, 0.0),
              child: add(widget.tabController.index)),
          toggle()
        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(0.0, _translateButton.value*3.0, 0.0),
            child: answer(),
          ),
          Transform(
              transform: Matrix4.translationValues(0.0, _translateButton.value * 2.0, 0.0),
              child: inbox()),
          Transform(
              transform: Matrix4.translationValues(0.0, _translateButton.value , 0.0),
              child: add(widget.tabController.index)),
          toggle()
        ],
      );
    }
  }
}