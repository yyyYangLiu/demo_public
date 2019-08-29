import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as lib;

class DataPage extends StatefulWidget{

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  String latitude = "";
  String longitude = "";

  readData() async {
    Prediction result = await PlacesAutocomplete.show(
        context: context,
        apiKey: 'AIzaSyCU7wL_HSBgCqouGMTbPt9CdTcXjazZ_qs',
        mode: Mode.overlay,
        language: "en",
        components: [
          Component(Component.country, "ca")
        ]);
    print(result);
  }

  var location = new lib.Location();

  @override
  Widget build(BuildContext context) {
    location.onLocationChanged().listen((LocationData currentLocation) {
      if (mounted){
        setState(() {
          latitude = currentLocation.latitude.toString();
          longitude = currentLocation.longitude.toString();
        });
      }

    });


    return Scaffold(

      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: <Widget>[
                Text(latitude,style: TextStyle(color: Colors.black,fontSize: 30.0,fontWeight: FontWeight.bold),),
                Text(longitude,style: TextStyle(color: Colors.black,fontSize: 30.0,fontWeight: FontWeight.bold),),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


