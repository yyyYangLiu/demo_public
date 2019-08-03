

import 'package:demo/own/floating_page/widget/DateTimeItem.dart';
import 'package:flutter/material.dart';

class CreateTemplate extends StatefulWidget{
  List<TemplateItem> templates;
  CreateTemplate({this.templates,});

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

    _addTimes(){
      setState(() {
        widget.time.add(TimeItem(time: TimeOfDay(hour: 0, minute: 0),));
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

    return Visibility(
      visible: _isFreq,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radio),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                    child: Text("Begin time", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),)),
              ),
              TimeItem(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Finish time", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),)),
              ),
              TimeItem(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Difference", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),)),
              ),
              MinutesItem()
            ],
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