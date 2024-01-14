
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/Admin/Pages/geofence.dart';
import 'package:fyp2/Models/geofence.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async';


class geolocationEditor extends StatefulWidget {
  const geolocationEditor({Key? key}) : super(key: key);

  @override
  State<geolocationEditor> createState() => _geolocationEditorState();
}

class _geolocationEditorState extends State<geolocationEditor> {


  static const kGoogleApiKey = "AIzaSyDyyg-B8sWDHWfvAtRv1wB_yDuUur1zRq0";
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  GeofenceModel geofenceModel = GeofenceModel();
  late GoogleMapController _controller;
  List<Marker> myMarker = [];

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection('admin')
        .doc('Geofence')
        .get()
        .then((value) {
      geofenceModel = GeofenceModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    final value1 = ("${geofenceModel.latitude}");
    final value2 = ("${geofenceModel.longitude}");

    double latitude = double.parse(value1);
    double longitude = double.parse(value2);

    Marker _kGooglePlexMarker = Marker(
      markerId: const MarkerId('_kGooglePlex'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(latitude, longitude),
      onTap: (){
        _handleTap;
      },
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        title: const Text("Google Map"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(children: [
            Expanded(child: SearchLocation(
              apiKey: "AIzaSyDyyg-B8sWDHWfvAtRv1wB_yDuUur1zRq0",
              // The language of the autocompletion
              language: 'en',
              //Search only work for this specific country
              country: 'MY',
              onSelected: (Place place) async {
                displayPrediction(place);
              },
            ),),
          ],),
          Expanded(
            child: GoogleMap(
              // markers: Set.from(myMarker),
              mapType: MapType.hybrid,
              markers: {
                _kGooglePlexMarker
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom:18,
              ),
              onMapCreated: (GoogleMapController controller){
                setState(() {
                  _controller=controller;
                });
              },
              onTap: _handleTap,
            ),
          ),
        ],
      ),
    );
  }

  _handleTap(LatLng tappedPoint){
    double newLatitude=0;
    double newLongitude=0;
    print(tappedPoint);

    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed:  () {
        setState(() {
          myMarker = [];
          myMarker.add(
            Marker(
              markerId: MarkerId(tappedPoint.toString()),
              position: tappedPoint,
            ),
          );
          newLatitude = tappedPoint.latitude;
          newLongitude = tappedPoint.longitude;
          updateLocation(newLatitude, newLongitude);
          updateCurrentDevice();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const geofenceEditor()));
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Location Editor"),
      content: const Text("Are you sure want change the location?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }

  Future<void> displayPrediction(Place place) async {
    if (place != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(place.placeId);
      var placeId = place.placeId;
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;
      print(lat);
      print(lng);
      await _controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lat,lng),
          zoom: 18)));
    }
    else{
      print("error");
    }
  }

}

Future updateLocation(double newLatitude, double newLongitude) async{

  final CollectionReference geo = FirebaseFirestore.instance.collection('admin');

  return await geo.doc('Geofence').update({'latitude':newLatitude, 'longitude': newLongitude} );
}

Future updateCurrentDevice() async{

  final CollectionReference geo = FirebaseFirestore.instance.collection('admin');

  return await geo.doc('Geofence').update({'totalDevice':0} );
}