

import 'package:demo/CustomItem/FancyFab.dart';
import 'package:demo/data/data_page.dart';
import 'package:demo/data/floating_page/addOrsearchPage.dart';

import 'package:demo/own/own_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      child: Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: <Widget>[
          TabBarView(
            controller: _tabController,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              DataPage(),
              OwnPage()
            ],
          ),
          Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 70.0),
            child: FancyFab(
              tabController: _tabController,
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