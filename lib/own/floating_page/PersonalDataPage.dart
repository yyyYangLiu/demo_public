import 'package:demo/dataBase/StoreModel/OwnDataModel.dart';
import 'package:demo/own/floating_page/widget/CreateAnswer.dart';
import 'package:demo/own/floating_page/widget/CreateTemplate.dart';
import 'package:demo/own/floating_page/widget/NewCustomDayTemplateSelector.dart';
import 'package:demo/own/floating_page/widget/TypeBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PersonalDataPage extends StatefulWidget{
  String name;
  PersonalDataPage(this.name);

  @override
  PersonalDataPageState createState() => PersonalDataPageState();
}

class PersonalDataPageState extends State<PersonalDataPage> {
  final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  List<TemplateItem> templates = [];
  List<Answer> answers = [];
  List<DayTemplateSelector> daytemplateSelector = [];
  String selectType = "";
  bool isSelectedM = false;

  @override
  void initState() {
    for (int i=0; i <= 6; i++){
      daytemplateSelector.add(DayTemplateSelector(templates: templates,Templateindex: 0,Dayindex: i,isSelectedDay: false,));
    }
    super.initState();
  }


  int day = 0;
  int counts = 0;

  _saveToDataBase(){
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

      OwnDataModel(
        name: widget.name,
        type: selectType,
        answer: fliteranswers.map((item) => item.text).toList(),
        template: [],
        day: filterdaytemplate.map((item) => labels[item.Dayindex]).toList(),
        templateSelect: filterdaytemplate.map((item) => item.Templateindex).toList()
      );
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
                  }else{
                    isSelectedM = false;
                  }
                });

              },),
              // Create Answers
              CreateAnswer(isMul: isSelectedM, answerslist: answers,),
              // New Day Selector
              NewCustomDayTemplateSelector(list: daytemplateSelector,),
              // Template Creator
              CreateTemplate(templates: templates,),
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

