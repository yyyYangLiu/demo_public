

import 'package:demo/AnswerPage/AnswerDialog.dart';
import 'package:demo/own/floating_page/PersonalDataPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      child: FloatingActionButton(
        heroTag: "add",
        onPressed: (){
          if (index == 1){
            _showDialog();
          }
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
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

  Widget answer(){
    return new Container(
      child: FloatingActionButton(
        heroTag: "answer",
        onPressed: (){
          AnswerDialog(context);
        },
        child: Icon(Icons.alarm),),

    );
  }

  Widget toggle(){
    return Container(
      child: FloatingActionButton(
        heroTag: "toggle",
        backgroundColor: _animateColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
            progress: _animateIcon,
        )
      ),
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