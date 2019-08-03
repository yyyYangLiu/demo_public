


import 'package:demo/own/floating_page/widget/CreateTemplate.dart';
import 'package:flutter/material.dart';

class NewCustomDayTemplateSelector extends StatelessWidget{
  List<DayTemplateSelector> list;
  NewCustomDayTemplateSelector({this.list});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: list,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}


class DayTemplateSelector extends StatefulWidget{

  List<TemplateItem> templates;
  int Templateindex;
  int Dayindex;
  bool isSelectedDay;

  DayTemplateSelector({this.templates,this.Templateindex, this.Dayindex,this.isSelectedDay});

  @override
  _DayTemplateSelectorState createState() => _DayTemplateSelectorState();
}

class _DayTemplateSelectorState extends State<DayTemplateSelector> {
  final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  bool isSelectedTemplate = false;

  bool isAnimatTemplate = false;
  bool isVisibilityTemplate = false;

  _changeNumber(){
    List<bool> bool_list = widget.templates.map((item) => item.isExist).toList();
    bool isNotTouch = true;
    int count = 0;
    setState(() {
      while (isNotTouch){
        if (count == bool_list.length){
          isNotTouch = false;
        }
        widget.Templateindex ++;
        if (widget.Templateindex <= bool_list.length - 1){
          if (bool_list[widget.Templateindex]){
            isNotTouch = false;
          }
        }else{
          widget.Templateindex = -1;
        }
        count ++;
      }
      isSelectedTemplate = !isSelectedTemplate;
    });
  }

  _setSelectedDay(){
    widget.isSelectedDay = !widget.isSelectedDay;
    if (!widget.isSelectedDay){
      isSelectedTemplate = false;
    }
  }

  _setVisibilityTemplate(){

    setState(() {
      isVisibilityTemplate = widget.isSelectedDay;
    });
  }

  _setAnimateTemplate(){
    print("get in first");
    setState((){
      isAnimatTemplate = widget.isSelectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: RawMaterialButton(
              onPressed: () async {
                _setSelectedDay();
                if (widget.isSelectedDay == true){
                  _setVisibilityTemplate();
                  await Future.delayed(const Duration(milliseconds: 100));
                  _setAnimateTemplate();
                }
                if (widget.isSelectedDay == false){
                  _setAnimateTemplate();
                  await Future.delayed(const Duration(milliseconds: 310));
                  _setVisibilityTemplate();
                }
              },
              splashColor: Colors.transparent,
              elevation: widget.isSelectedDay ? 4.0 : 2.0,
              shape: CircleBorder(side: BorderSide.none),
              constraints: BoxConstraints(minWidth: 40, minHeight: 40),
              fillColor: widget.isSelectedDay ? Colors.red : Colors.white,
              textStyle: Theme.of(context).textTheme.button,
              child: Text(labels[widget.Dayindex], style: TextStyle(color: widget.isSelectedDay ? Colors.white : Colors.black)),
            ),
          ),
          Visibility(
            visible: isVisibilityTemplate,
            child: AnimatedOpacity(
              opacity: isAnimatTemplate ? 1.0 :0.0,
              duration: Duration(milliseconds: 300),
              child: RawMaterialButton(
                onPressed: (){
                  setState(() {
                    if (widget.isSelectedDay){
                      _changeNumber();
                    }
                  });
                },
                splashColor: Colors.transparent,
                elevation: 2.0 ,
                shape: CircleBorder(side: BorderSide.none),
                constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                fillColor: Colors.white,
                textStyle: Theme.of(context).textTheme.button,
                child: Text(widget.Templateindex.toString(), style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}