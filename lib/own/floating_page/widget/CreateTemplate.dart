

import 'package:demo/own/floating_page/widget/DateTimeItem.dart';
import 'package:flutter/material.dart';

class CreateTemplate extends StatefulWidget{
  List<TemplateItem> templates;
  bool isMap;
  CreateTemplate({this.templates,this.isMap});

  @override
  _CreateTemplateState createState() => _CreateTemplateState();
}

class _CreateTemplateState extends State<CreateTemplate> {

  int counts = 0;

  @override
  void initState() {
    widget.templates.add(new TemplateItem(index: counts, templates: widget.templates, isExist: true, time: [],));
    print(widget.templates.map((item) => item.index).toList());
    super.initState();
  }

  addTemplates(){
    setState(() {
      counts ++;
      widget.templates.add(new TemplateItem(index: counts, templates: widget.templates, isExist: true, time: [],));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 400,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Stack(
            children: <Widget>[
              ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: widget.templates,
                  ),
                  // Load More
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: RawMaterialButton(
                  constraints: BoxConstraints(minWidth: 30, minHeight: 30),
                  child: Icon(Icons.add,color: Colors.white,),
                  elevation: 2.0,
                  onPressed: (){addTemplates();},
                  fillColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)
                  ),
                ),
              )
              ],
            ),
          )

        ],
      ),
    );
  }
}


class TemplateItem extends StatefulWidget{
  int index;
  List<TemplateItem> templates;
  bool isExist;
  List<TimeItem> time;
  TemplateItem({this.index,this.templates, this.isExist, this.time});

  @override
  _TemplateItemState createState() => _TemplateItemState();

}

class _TemplateItemState extends State<TemplateItem> {


  double _radio = 15.0;

  bool _isCustom = false;
  bool _isFreq = false;
  bool _isSelected = false;
  bool _showFreqPage = false;

  bool isV = true;
  bool isA = true;


  _CustomCreate(){
    setState(() {
      _isCustom = true;
      _isSelected = true;
    });

  }

  _FreqCreate(){
    setState(() {
      _isFreq = true;
      _isSelected = true;
    });
  }

  _SelectedPage(){
    return Visibility(
      visible: !_isSelected,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RawMaterialButton(
                onPressed: (){
                  _CustomCreate();
                },
                elevation: 2.0,
                fillColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RawMaterialButton(
                onPressed: (){
                  _FreqCreate();
                },
                elevation: 2.0,
                fillColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _CustomPage(){

    DateTime time = DateTime.now();

    _addTimes(){
      setState(() {
        widget.time.add(TimeItem(time: TimeOfDay(hour: time.hour, minute: time.minute),));
      });
    }

    return Visibility(
      visible: _isCustom,
      child: Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radio),
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Column(
                children: widget.time,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RawMaterialButton(
                  constraints: BoxConstraints(minWidth: 30, minHeight: 30),
                  child: Icon(Icons.add,color: Colors.white,),
                  elevation: 2.0,
                  onPressed: (){_addTimes();},
                  fillColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _FreqPage(){

    DateTime time = DateTime.now();
    TimeItem start = TimeItem(time: TimeOfDay(hour: time.hour, minute: time.minute));
    TimeItem end = TimeItem(time:TimeOfDay(hour: time.hour, minute: time.minute));
    MinutesItem gap = MinutesItem(minutes: 1,);


    return Visibility(
      visible: _isFreq,
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radio),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                      child: Text("Start", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17.0),)),
                ),
                start,
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 4.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("End", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17.0),)),
                ),
                end,
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 4.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Gap", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17.0),)),
                ),
                gap,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RawMaterialButton(
                      onPressed: (){
                        print(start.time.runtimeType);
                        print(start.time);
                        print(end.time);
                        print(gap.minutes);
                        DateTime Dstart = DateTime(time.year, time.month, time.day, start.time.hour, start.time.minute);
                        DateTime Dend = DateTime(time.year,time.month,time.day,end.time.hour,end.time.minute);

                        int checkDate = Dstart.compareTo(Dend);
                        print(checkDate);
                        print(checkDate == -1);
                        while (checkDate == -1){
                          print("get inside");
                          if (checkDate == -1){
                            widget.time.add(TimeItem(time: TimeOfDay(hour: Dstart.hour, minute: Dstart.minute),));
                          }
                          Dstart = Dstart.add(Duration(minutes: gap.minutes));
                          checkDate = Dstart.compareTo(Dend);
                        }
                        print(widget.time);
                        setState(() {
                          _isFreq = false;
                          _isCustom = true;
                        });

                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Text("Create",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: isV,
      child: AnimatedOpacity(
        opacity: isA ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: RawMaterialButton(
            onPressed: (){
              print(widget.index);
              print(widget.templates.map((item) => item.index).toList());
            },
            splashColor: Colors.transparent,
            fillColor: Colors.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radio)
            ),
            child: Container(
              width: 250,
              child: Stack(
                children: <Widget>[
                  //select page
                  _SelectedPage(),
                  //custom page
                  _CustomPage(),
                  // freq page
                  _FreqPage(),
                  // close buttom
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          List<bool> checkBool = widget.templates.map((item) => item.isExist).toList();
                          var map = Map();
                          checkBool.forEach((x) => map[x] = !map.containsKey(x) ? (1) : (map[x]+1));
                          if (map[true] != 1 ){
                            widget.isExist = false;
                            setState(() {
                              isA = widget.isExist;
                            });
                            await Future.delayed(Duration(milliseconds: 310));
                            setState(() {
                              isV = widget.isExist;
                            });

                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                              color: Colors.red,
                              child: Icon(Icons.close, color: Colors.white,),),
                        ),
                      ),
                    ),
                  ),
                  // page index
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.index.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}