import 'package:flutter/material.dart';

class LocalItem extends StatefulWidget{
  String name;
  String type;
  double percentage;
  double count;
  Color color;
  LocalItem({this.type,this.percentage,this.count,this.color,this.name});

  @override
  _localItemState createState() => _localItemState();
}

class _localItemState extends State<LocalItem> with TickerProviderStateMixin{

  @override
  void dispose() {
    super.dispose();
  }
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

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 300),
            child: Container(
              height: 50,
              width: widget.count != null ? 400 * widget.percentage : 0,
              color: widget.color,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(widget.count != null ? widget.count.toInt().toString() + " "+widget.name: "",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  )),
            ),
          ),
        ),
      );
    }
  }

}