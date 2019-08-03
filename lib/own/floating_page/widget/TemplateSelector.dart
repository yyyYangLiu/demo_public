

import 'package:demo/own/floating_page/widget/CreateTemplate.dart';
import 'package:flutter/material.dart';

class TemplateSelector extends StatefulWidget{
  List<TemplateItem> templates;
  List<SelectorItem> templateSelector;
  TemplateSelector({this.templates,this.templateSelector});

  @override
  _TemplateSelectorState createState() => _TemplateSelectorState();
}

class _TemplateSelectorState extends State<TemplateSelector> {


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: widget.templateSelector,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}



class SelectorItem extends StatefulWidget {
  List<TemplateItem> templates;
  int index;
  SelectorItem({this.templates, this.index});
  @override
  _SelectorItemState createState() => _SelectorItemState();

}

class _SelectorItemState extends State<SelectorItem> {

  _changeNumber(){
    List<bool> bool_list = widget.templates.map((item) => item.isExist).toList();
    bool isNotTouch = true;
    int count = 0;
    setState(() {
      while (isNotTouch){
        if (count == bool_list.length){
          isNotTouch = false;
        }
        widget.index ++;
        if (widget.index <= bool_list.length - 1){
          if (bool_list[widget.index]){
            isNotTouch = false;
          }
        }else{
          widget.index = -1;
        }
        count ++;
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return RawMaterialButton(
      splashColor: Colors.transparent,
      onPressed: () {
          _changeNumber();
      },
      elevation: 2,
      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
      fillColor: Colors.white,
      textStyle: Theme.of(context).textTheme.button,
      child: Text(widget.index.toString(), style: TextStyle(color: Colors.black)),
      shape: CircleBorder(side: BorderSide.none),
    );
  }
}