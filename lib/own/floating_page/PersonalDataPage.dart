import 'dart:io';

import 'package:demo/dataBase/CustomDatabaseHelper.dart';
import 'package:demo/dataBase/DatabaseHelper.dart';
import 'package:demo/dataBase/StoreModel/OwnDataModel.dart';
import 'package:demo/own/floating_page/widget/CreateAnswer.dart';
import 'package:demo/own/floating_page/widget/CreateLocation.dart';
import 'package:demo/own/floating_page/widget/CreateTemplate.dart';
import 'package:demo/own/floating_page/widget/CustomDaySelector.dart';
import 'package:demo/own/floating_page/widget/NewCustomDayTemplateSelector.dart';
import 'package:demo/own/floating_page/widget/TypeBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';

class PersonalDataPage extends StatefulWidget{
  String name;
  Function updateMainPage;
  PersonalDataPage({this.name,this.updateMainPage});

  @override
  PersonalDataPageState createState() => PersonalDataPageState();
}

class PersonalDataPageState extends State<PersonalDataPage> {
  final dbHelper = DatabaseHelper.instance;
  final cdbHelper = CustomDatabaseHelper.instance;
  final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  List<TemplateItem> templates = [];
  List<Answer> answers = [];
  List<DayTemplateSelector> daytemplateSelector = [];
  String selectType = "";
  bool isSelectedM = false;
  bool isSelectedMa = false;

  List<LocationItem> locations = [];

  @override
  void initState() {
    for (int i=0; i <= 6; i++){
      daytemplateSelector.add(DayTemplateSelector(templates: templates,Templateindex: 0,Dayindex: i,isSelectedDay: false,));
    }
    super.initState();
  }

  int day = 0;
  int counts = 0;

  test() async {
    print("test");
    print(locations.map((item) => item.isExist).toList());
    print(locations.map((item) => item.location).toList());
    print(locations.map((item) => item.lat).toList());
    print(locations.map((item) => item.lng).toList());
  }
  _saveToDataBase() async {
      test();
      // name
      print(widget.name);
      // type
      print(selectType);
      // answer
      List<Answer> fliteranswers = answers.where((item) => item.isExist).toList();
      print(fliteranswers.map((item) => item.text).toList());
      // templates
      List<TemplateItem> filtertemplates = templates.where((item) => item.isExist).toList();
      print(filtertemplates.map((item) => item.time).toList());
      var list = filtertemplates.map((item) => item.time).toList();
      print(list[0].map((item) => item.time).toList());
      print(filtertemplates.map((item) => item.index).toList());
      // filter day templateSelector
      print(daytemplateSelector.map((item) => item.isSelectedDay).toList());
      List<DayTemplateSelector> filterdaytemplate = daytemplateSelector.where((item) => item.isSelectedDay).toList();
      print(filterdaytemplate.map((item) => labels[item.Dayindex]).toList());
      print(filterdaytemplate.map((item) => item.Templateindex).toList());
      //check tempaltes
      List<TemplateModel> templatemodel = filtertemplates.map((item) => TemplateModel(index: item.index, time: list[item.index].map((item) => item.time).toList())).toList();

      // put data into Database
      _insertDatabase();

      final allRows = await dbHelper.queryAllRows();
      print('query all rows:');
      allRows.forEach((row) => print(row));

      List<OwnDataDataBase> outputlist = [];
      final check = await dbHelper.getData(widget.name);
      outputlist.add(OwnDataDataBase(id: check[0]["id"], name: check[0]["name"]));

      widget.updateMainPage(outputlist);

      // inputJson
      OwnDataModel owndatatest =

      OwnDataModel(
          name: widget.name,
          type: selectType,
          answer: fliteranswers.map((item) => item.text).toList(),
          template: templatemodel,
          day: filterdaytemplate.map((item) => labels[item.Dayindex]).toList(),
          templateSelect: filterdaytemplate.map((item) => item.Templateindex).toList()
      );

      // InputJson Data
      final String inputJson = clientToJson(owndatatest);
      print(clientToJson(owndatatest));
      // Create Data into txt
      _createFile(inputJson);
      _readFile();

      Navigator.of(context).pop();
  }

  _insertDatabase() async {
    // check if the uniqueid is unique
    bool isNotEmpty = true;
    String uniqueId = randomAlpha(31);
    print(uniqueId);
    var checkData = dbHelper.checkUnique(uniqueId);
    checkData.then((response){
      print(response);
      isNotEmpty = response.length != 0;
    });

    if (isNotEmpty){
      print("get into change random value");
      uniqueId = randomAlpha(31);
    }

    print(uniqueId);

    DateTime now = DateTime.now();

    String createDate = now.year.toString() + ":" + now.month.toString() + ":" + now.day.toString();

    Map<String, dynamic> row = {
      DatabaseHelper.columnName : widget.name,
      "uniqueId" : uniqueId,
      "createDate" : createDate
    };

    final id = await dbHelper.insert(row);
    print('inserted row id: $id');


    print("get into function");
    var db = cdbHelper.database;
    db.then((database){
      cdbHelper.onCreate(database, uniqueId);
    });

  }

  _createFile(inputJson) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    print(path);
    final file = await File('$path/${widget.name}.txt');
    file.writeAsStringSync(inputJson);
  }

  _readFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = await File('$path/${widget.name}.txt');
    String contents = await file.readAsString();
    print(contents);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              //Name
              Center(
                child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text(widget.name,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0),)),
              ),
              // Type Bar
              TypeBar(selectType: selectType,changeType: (text){
                selectType = text;
                setState(() {
                  if (text == "mul"){
                    isSelectedM = true;
                    isSelectedMa = false;
                  }else if (text == "map") {
                    isSelectedMa = true;
                    isSelectedM = false;
                    print("get into map");
                  }else{
                    isSelectedM = false;
                    isSelectedMa = false;
                  }
                });

              },),
              // Create map location
              CreateLocation(isMap: isSelectedMa, locationlist: locations),
              // Create Answers
              CreateAnswer(isMul: isSelectedM, answerslist: answers,),
              // New Day Selector
              NewCustomDayTemplateSelector(list: daytemplateSelector,),
              // Template Creator
              CreateTemplate(templates: templates, isMap: isSelectedMa),
              // save area
              Container(
                color: Colors.transparent,
                height: 50,
              )
            ],
          ),
          //Submit Buttom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RawMaterialButton(
                onPressed: () {
                  _saveToDataBase();
                },
                elevation: 2.0,
                fillColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Save", style:TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

