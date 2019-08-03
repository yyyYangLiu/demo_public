

import 'package:flutter/material.dart';

class CreateAnswer extends StatefulWidget{

  bool isMul;
  List<Answer> answerslist;
  CreateAnswer({this.isMul, this.answerslist});

  @override
  _CreateAnswerState createState() => _CreateAnswerState();
}

class _CreateAnswerState extends State<CreateAnswer> {


  int index = 0;

  @override
  void initState() {

    widget.answerslist.add(Answer(index: index, isExist: true, text: "+",));
    super.initState();
  }

  addAnswers(){
    print("touch");
    setState(() {
      index ++;
      widget.answerslist.add(Answer(index: index, isExist: true, text: "+",));
    });
    print(widget.answerslist);
  }

  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: widget.isMul,
      child: Container(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 400,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Row(
                            children: widget.answerslist,
                          ),
                        ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RawMaterialButton(
                      constraints: BoxConstraints(minWidth: 30, minHeight: 30),
                      child: Icon(Icons.add,color: Colors.white,),
                      elevation: 2.0,
                      onPressed: (){addAnswers();},
                      fillColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Answer extends StatefulWidget{
  int index;
  bool isExist;
  String text;
  Answer({this.index, this.isExist, this.text});

  @override
  _AnswerState createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  bool isA = true;
  bool isV = true;

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: new TextField(
          onSubmitted: (Text){
            setState(() {
              widget.text = Text;
              Navigator.pop(context);
            });
          },
          autocorrect: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name : ",
              hintText: 'Create a name'),
          style: TextStyle(color: Colors.blue),
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
          padding: const EdgeInsets.all(10.0),
          child: RawMaterialButton(
            onPressed: (){
              _showDialog();
            },
            splashColor: Colors.transparent,
            elevation: 2.0,
            constraints: BoxConstraints(minHeight: 100,minWidth: 100),
            fillColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
            ),
            child: Container(
              width: 100,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.text,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          widget.isExist = false;
                          setState(() {
                            isA = widget.isExist;
                          });
                          await Future.delayed(Duration(milliseconds: 310));
                          setState(() {
                            isV = widget.isExist;
                          });
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}