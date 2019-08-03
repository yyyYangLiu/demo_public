

import 'package:demo/own/floating_page/PersonalDataPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget{

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  
  TextEditingController enterController = new TextEditingController();

  _showDialog() async {
    await showDialog<String>(
        context: context,
        child: new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: new TextField(
                    controller: enterController,
                    autocorrect: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Name : ",
                        hintText: 'Create a name'),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Flexible(
                  child: RawMaterialButton(
                    fillColor: Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (BuildContext context){
                            return PersonalDataPage(enterController.text);
                          }
                      ));
                    },
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Create",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: (){
                    _showDialog();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      color: Colors.blue,
                      width: 200,
                      height: 200,
                      child: Center(child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text("Personal Data",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0))))
                    ),
                  ),
                ),
              ),
            ),

            Flexible(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      color: Colors.blue,
                      width: 200,
                      height: 200,
                      child: Center(child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text("Custom Data",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),))),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
              child: Icon(Icons.close,color: Colors.red, size: 30.0,)),

          Padding(
            padding: EdgeInsets.all(10.0),
              child: Icon(Icons.arrow_back,color: Colors.blue, size: 30.0,)),
        ],
      ),
    );
  }
}