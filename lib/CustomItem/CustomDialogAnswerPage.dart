
import 'dart:math';
import 'package:demo/CustomItem/widget/AnswerItem.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/dataBase/StoreModel/OwnDataModel.dart';
import 'package:flutter/material.dart';

class CustomDialogAnswerPage extends StatefulWidget{


  @override
  _CustomDialogAnswerPageState createState() => _CustomDialogAnswerPageState();
}

class _CustomDialogAnswerPageState extends State<CustomDialogAnswerPage> {

  var currentPage;
  final dbHelper = DatabaseHelper.instance;

  List<Widget> cardList = new List();
  List<OwnDataDataBase> list = new List();

  initState(){
    _loadData();
    super.initState();
  }

  _loadData() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      allRows.forEach((row) => list.add(OwnDataDataBase(id: row["_id"],name: row["name"])));
      cardList.addAll(list.map((text) => AnswerItem(name: text.name, )).toList());
    });
    currentPage = cardList.length.toDouble() - 1.0;
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = new PageController(initialPage: cardList.length - 1);
    controller.addListener((){
      setState(() {
        currentPage = controller.page;
      });
    });
    if (cardList.length != 0){
      return Container(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: PageView.builder(
              itemCount: cardList.length,
              controller: controller,
              reverse: true,
              itemBuilder: (context,index){
                return Container();
            },)),
            CardScrollWidget(
                currentPage: currentPage,list: cardList),

          ],
        ),
      );
    }else{
      return Container();
    }
  }
}

var cardAspectRatio = 12.0/16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class CardScrollWidget extends StatefulWidget{
  var currentPage;
  List<Widget> list;

  CardScrollWidget({this.currentPage,this.list});

  @override
  CardScrollWidgetState createState() => CardScrollWidgetState();
}

class CardScrollWidgetState extends State<CardScrollWidget> {
  var padding = 40.0;
  var BottomPadding = 80.0;
  var verticalInset = 20.0;
  var BottomVerticalInset = 40.0;
  @override
  Widget build(BuildContext context) {
    List<Widget> locallist = new List();
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
          builder: (context,contraints){
            var width = contraints.maxWidth;
            var height = contraints.maxHeight;

            var safeWidth = width - 2 * padding;
            var safeHeight = height - 2 * padding;

            var heightOfPrimaryCard = safeHeight;
            var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

            var primaryCardLeft = safeWidth - widthOfPrimaryCard;
            var horizontalInset = primaryCardLeft / 2;
            for(var i = 0; i< widget.list.length; i++){
              var delta = i - widget.currentPage;
              bool isOnRight = delta > 0;

              var start = padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);

              var topbottom = padding + verticalInset * max(-delta,0.0);

              var top = max(padding + verticalInset * delta,0.0);

              var bottom = min(BottomPadding - BottomVerticalInset * delta,160.0);

              var cardItem = Positioned.directional(
                top: top,
                bottom: bottom,
                start: start,
                textDirection: TextDirection.rtl,
                child: widget.list[i],
              );
              locallist.add(cardItem);
            }
            return Stack(
              children: locallist,
            );
          }),);
  }
}

