

import 'package:flutter/material.dart';

import '../../httpRequest.dart';

class AddOrSearchPage extends StatefulWidget{

  @override
  _AddOrSearchPageState createState() => _AddOrSearchPageState();
}

class _AddOrSearchPageState extends State<AddOrSearchPage> {
  String _response = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: BackButton(color: Colors.black,),
        title: Text("AddOrSearch_Page",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: (){
            httpRequest.get("/test/get_information", queryParameters: {"types": 1,"name" : "jeff"}).then((response){
              setState(() {
                _response = response.toString();
              });
            });
          },
          child: Container(
            color: Colors.white,
            width: 1000,
            height: 80,
            child: Text(_response),

          ),
        ),
      ),
    );
  }
}