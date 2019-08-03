import 'package:flutter/material.dart';

class DataDetailsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        brightness: Brightness.light,
        title: Text("Details_Page",style: TextStyle(color: Colors.black),),
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }


}