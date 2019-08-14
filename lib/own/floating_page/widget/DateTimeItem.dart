


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class DateTimeItem extends StatefulWidget{

  bool check;
  DateTimeItem({this.check});

  @override
  _DateTimeItemState createState() => _DateTimeItemState();
}

class _DateTimeItemState extends State<DateTimeItem> {

  DateTime _date = DateTime.now();

  TimeOfDay _time = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _date,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date){
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time){
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.check,
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                _selectDate(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.blue,
                  child: Center(child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(DateFormat.yMMMd().format(_date),style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0)))),
                )
              ),
            ),
            GestureDetector(
              onTap: (){
                _selectTime(context);
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.blue,
                    child: Center(child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(_time.format(context),style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0)))),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TimeItem extends StatefulWidget{
  TimeOfDay time;
  TimeItem({this.time});

  @override
  _TimeItemState createState() => _TimeItemState();
}

class _TimeItemState extends State<TimeItem> {


  Future<void> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: widget.time,
    );
    if (picked != null && picked != widget.time){
      setState(() {
        widget.time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          _selectTime(context);
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              color: Colors.blue,
              child: Center(child: Padding(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Text(widget.time.format(context),style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)),
              )),
            )
        ),
      ),
    );
  }
}


class MinutesItem extends StatefulWidget{
  int minutes;
  MinutesItem({this.minutes});
  @override
  _MinutesItemState createState() => _MinutesItemState();
}

class _MinutesItemState extends State<MinutesItem> {


  _showDialog(){
    showDialog<int>(
      context: context,
      builder: (BuildContext context){
        return new NumberPickerDialog.integer(
            minValue: 1, maxValue: 60, initialIntegerValue: widget.minutes);
      }).then((value){
        if (value != null){
          setState( () => widget.minutes = value);
        }
      });

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          _showDialog();
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              color: Colors.blue,
              child: Center(child: Padding(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Text(widget.minutes.toString(),style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0)),
              )),
            )
        ),
      ),
    );
  }
}