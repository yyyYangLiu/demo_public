
import 'dart:convert';

import 'package:flutter/material.dart';


String clientToJson(OwnDataModel data){
  final dyn = data.toJson();
  return json.encode(dyn);
}

class OwnDataDataBase{
  int id;
  String name;
  OwnDataDataBase({this.id,this.name});

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name
  };
}

class OwnDataModel{

  String name;
  String type;
  List<String> answer;
  List<LocationModel> locations;
  List<TemplateModel> template;
  List<String> day;
  List<int> templateSelect;

  OwnDataModel({
    this.name,
    this.type,
    this.answer,
    this.locations,
    this.template,
    this.day,
    this.templateSelect,
  });

  Map<String, dynamic> toJson() => {
    "name" : name,
    "type" : type,
    "answer" : answer,
    "locations" : locations.map((item) => item.toJson()).toList(),
    "template" : template.map((item) => item.toJson()).toList(),
    "day" : day,
    "templateSelect" : templateSelect
  };

}

class TemplateModel{
  int index;
  List<TimeOfDay>  time;

  TemplateModel({this.index, this.time});

  Map<String, dynamic> toJson() =>{
    "index" : index,
    "time" : time.map((item) => item.toString()).toList()
  };

}


class LocationModel{
  String location;
  double lat;
  double lng;

  LocationModel({this.location,this.lat,this.lng});

  Map<String, dynamic> toJson() =>{
    "location" : location,
    "lat" : lat,
    "lng" : lng
  };

}