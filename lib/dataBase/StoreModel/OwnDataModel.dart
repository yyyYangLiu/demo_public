



import 'package:flutter/material.dart';

class OwnDataModel{

  String name;
  String type;
  List<String> answer;
  List<TemplateModel> template;
  List<String> day;
  List<int> templateSelect;

  OwnDataModel({
    this.name,
    this.type,
    this.answer,
    this.template,
    this.day,
    this.templateSelect,
  });

  factory OwnDataModel.fromJson(Map<String,dynamic> json){

    return OwnDataModel(
      name: json["name"],
      type: json["type"],
      answer: json["answer"],
      template: json["template"],
      day: json["day"],
      templateSelect: json["templateSelect"]
    );
  }

}

class TemplateModel{
  int index;
  List<TimeOfDay>  time;

  TemplateModel({this.index, this.time});


}