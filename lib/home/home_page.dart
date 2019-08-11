import 'package:demo/CustomItem/FancyFab.dart';
import 'package:demo/data/data_page.dart';

import 'package:demo/own/own_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:demo/dataBase/DatabaseHelper.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;
  final dbHelper = DatabaseHelper.instance;
  GlobalKey<OwnPageState> _keyOwnPage = GlobalKey();


  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }


  deleteAll() async {
    await dbHelper.deleteAll();
    _keyOwnPage.currentState.deleteAll();
  }

  updateData(updatelist) async {
      print("get into zero");
      _keyOwnPage.currentState.updateList(updatelist);
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      child: Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: <Widget>[
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll){
              overscroll.disallowGlow();
            },
            child: TabBarView(
              controller: _tabController,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                DataPage(),
                OwnPage(
                  key: _keyOwnPage,
                )
              ],
            ),
          ),
          Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 70.0),
            child: FancyFab(
              tabController: _tabController,
              onPressed: updateData,
              onDelete: deleteAll,
            ),
          ),),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: Colors.blue,
                      labelColor: Colors.red,
                      controller: _tabController,
                      tabs: [
                        Tab(icon: Icon(Icons.assessment),),
                        Tab(icon: Icon(Icons.book),)
                      ]),
                ),
              ),
            ),
          ),
        ],
      )
      ),
      length: 2,
    );
  }
}