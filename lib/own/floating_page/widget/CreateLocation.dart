

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class CreateLocation extends StatefulWidget{
  bool isMap;
  List locationlist;
  CreateLocation({this.isMap,this.locationlist});

  @override
  _CreateLocationState createState() => _CreateLocationState();
}

class _CreateLocationState extends State<CreateLocation> {

  addLocation(text,lat,lng){
    setState(() {
      widget.locationlist.add(LocationItem(location: text,lat: lat,lng: lng,isExist: true,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isMap,
      child: Container(
        height: widget.locationlist.length != 0 ? 300 : 50,
        child: Stack(
          children: <Widget>[
            Container(
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Row(
                    children: widget.locationlist,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: addButton(add: addLocation))
          ],
        ),
      ),
    );
  }
}

class addButton extends StatefulWidget{
  Function add;
  addButton({this.add});
  @override
  _addButtonState createState() => _addButtonState();
}

class _addButtonState extends State<addButton> {

  onSearch() async {
    Prediction result = await PlacesAutocomplete.show(
        context: context,
        apiKey: 'AIzaSyAw1xtR8Hm3ZEnlIV9xLbSNNuK1o4CrQ8s',
        mode: Mode.overlay,
        language: "en",
        logo: Container(height: 0,),
        onError: (e){
          print(e.errorMessage);
        },
        components: [
          Component(Component.country, "ca")
        ]);

    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyAw1xtR8Hm3ZEnlIV9xLbSNNuK1o4CrQ8s');
    if (result != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(result.placeId);

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      print(result.description);
      print(lat);
      print(lng);
      widget.add(result.description,lat,lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(minWidth: 30, minHeight: 30),
      child: Icon(Icons.add,color: Colors.white,),
      elevation: 2.0,
      onPressed: (){
        onSearch();},
      fillColor: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
      ),
    );
  }
}

class LocationItem extends StatefulWidget{
  String location;
  double lat;
  double lng;
  bool isExist;
  LocationItem({this.location,this.lat,this.lng,this.isExist});

  @override
  _LocationItemState createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  String location = "";
  initState(){
    location = widget.location;
    super.initState();
  }

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
                location = Text;
                Navigator.pop(context);
              });
            },
            autocorrect: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Location : ",
                hintText: 'Change location name'),
            style: TextStyle(color: Colors.blue),
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isExist,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RawMaterialButton(
          onPressed: (){
            _showDialog();
          },
          elevation: 2.0,
          fillColor: Colors.white,
          splashColor:  Colors.transparent,
          constraints: BoxConstraints(minWidth: 50,maxWidth: 200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(location,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0)),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        widget.isExist = false;
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
        )
      ),
    );
  }
}