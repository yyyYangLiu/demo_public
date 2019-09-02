


import 'package:demo/dataBase/GPSDatabaseHelper.dart';
import 'package:flutter/material.dart';

class ChildGPSShowListWidget extends StatefulWidget{
  String name;
  ChildGPSShowListWidget({this.name});

  @override
  _ChildGPSShowListWidgetState createState() => _ChildGPSShowListWidgetState();
}

class _ChildGPSShowListWidgetState extends State<ChildGPSShowListWidget> {
  var gpsdb = GPSDatabaseHelper.instance;

  List<Widget> gpslist = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData(){
    var data = gpsdb.queryAllRows();
    data.then((response){
      print(response);
      for (var i in response){
        setState(() {
          gpslist.add(GPSItem(name: i["name"],time: i["time"], latitude: i["latitude"],longitude: i["longitude"]));
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: gpslist,
    );
  }
}


class GPSItem extends StatelessWidget{
  String name;
  String time;
  double latitude;
  double longitude;
  GPSItem({this.name,this.time,this.latitude,this.longitude});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(name),
        Text(time),
        Text(latitude.toString()),
        Text(longitude.toString())
      ],
    );
  }
}