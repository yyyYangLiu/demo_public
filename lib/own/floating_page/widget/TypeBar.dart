


import 'package:flutter/material.dart';

class TypeBar extends StatefulWidget{
  String selectType;
  Function changeType;
  TypeBar({this.selectType,this.changeType});

  @override
  _TypeBarState createState() => _TypeBarState();
}

class _TypeBarState extends State<TypeBar> {
  var _yes = Colors.white;

  var _mul = Colors.white;

  var _ent = Colors.white;

  bool isSelectedY = false;

  bool isSelectedM = false;

  bool isSelectedE = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RawMaterialButton(
              elevation: isSelectedY ? 4.0 : 2.0,
              splashColor: Colors.transparent,
              constraints: BoxConstraints(minWidth: 160, maxHeight: 50),
              onPressed: (){
                setState(() {
                  isSelectedY = true;
                  isSelectedM = false;
                  isSelectedE = false;
                  widget.selectType = "yes";
                  _yes = Colors.red;
                  _mul = Colors.white;
                  _ent = Colors.white;
                });
                widget.changeType("yes");
              },
              fillColor: _yes,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text("Yes/No", style: TextStyle(color: isSelectedY ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0),),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RawMaterialButton(
              elevation: isSelectedM ? 4.0 : 2.0,
              constraints: BoxConstraints(minWidth: 160),
              onPressed: (){
                setState(() {
                  isSelectedM = true;
                  isSelectedY = false;
                  isSelectedE = false;
                  widget.selectType = "mul";
                  _mul = Colors.red;
                  _yes = Colors.white;
                  _ent = Colors.white;

                });
                widget.changeType("mul");
              },
              fillColor: _mul,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text("Mult", style: TextStyle(color: isSelectedM ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0),),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RawMaterialButton(
              elevation: isSelectedE ? 4.0 : 2.0,
              constraints: BoxConstraints(minWidth: 160),
              onPressed: (){
                setState(() {
                  isSelectedE = true;
                  isSelectedM = false;
                  isSelectedY = false;
                  widget.selectType = "ent";
                  _ent = Colors.red;
                  _yes = Colors.white;
                  _mul = Colors.white;

                });
                widget.changeType("ent");
              },
              fillColor: _ent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Text("Enter", style: TextStyle(color: isSelectedE ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0),),
            ),
          ),
        ],
      ),
    );
  }
}