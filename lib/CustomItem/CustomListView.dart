



import 'package:flutter/material.dart';

class CustomListView extends StatefulWidget{

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  PageController controller = PageController();
  double currentPageValue = 0.0;

  initState(){
    controller.addListener((){
      setState(() {
        currentPageValue = controller.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
        itemCount: 10,
        itemBuilder:(context, position){
          if (position == currentPageValue.floor()){
            print("touch one");
            return Transform(
              transform:  Matrix4.identity()..rotateY(currentPageValue - position),
              child: Container(
                color: position % 2 == 0 ? Colors.blue : Colors.pink,
                child: Center(
                  child:  Text(
                    "page1",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ),
              ),
            );
          } else if (position == currentPageValue.floor() + 1){
            print("touch two");
            return Transform(
              transform: Matrix4.identity()..rotateX(currentPageValue-position),
              child: Container(
                color: position % 2 == 0 ? Colors.blue : Colors.pink,
                child: Center(
                  child: Text(
                    "Page2",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ),
              ),
            );
          } else {
            print("touch three");
            return Container(
              color: position % 2 == 0? Colors.blue : Colors.pink,
              child: Center(
                child: Text(
                  "Page3",
                  style: TextStyle(color: Colors.white, fontSize:  22.0),
                ),
              ),
            );
          }
        });
  }
}

