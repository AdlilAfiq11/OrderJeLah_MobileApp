import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/GeneralUser/subPages/stallList.dart';
import 'package:fyp2/Models/geofence.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../subPages/highlighted.dart';
import '../subPages/yourCart.dart';
import 'dart:async';
import 'package:fyp2/GeneralUser/Geofence/subGeofence/geoEngine.dart';
import 'package:fyp2/GeneralUser/Geofence/subGeofence/geoStatus.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  String? latitude, longitude, radius;
  HomePage({Key? key, this.latitude, this.longitude,  this.radius}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  User? user = FirebaseAuth.instance.currentUser;
  late StreamSubscription<GeofenceStatus> geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  GeofenceModel geofenceModel = GeofenceModel();

  String geofenceStatus = '';
  String latitude="";
  String longitude="";
  String radius="";
  bool isReady = false;
  late Position position;
  int device=0;
  dynamic data;


  late StreamSubscription _listener;
  int totalDevice=0;
  @override
  void initState() {
    super.initState();

    _listener = FirebaseFirestore.instance''
        .collection('users')
        .snapshots()
        .listen((snap) async {
      final cases = snap.docs.map((doc) => doc.data());

      totalDevice = 0;
      for (var caseData in cases) {
          if(caseData['account'] == 'Active' && caseData['status'] == 'IN')
          {
              totalDevice++;
              updateTotalDevice(totalDevice);
          }
      }
      if(totalDevice<0){
        totalDevice = 0;
        updateTotalDevice(totalDevice);
      }
    });


    FirebaseFirestore.instance
        .collection('admin')
        .doc('Geofence')
        .get()
        .then((value) {
      geofenceModel = GeofenceModel.fromMap(value.data());
      setState(() {
        latitude = ("${geofenceModel.latitude}");
        longitude = ("${geofenceModel.longitude}");
        radius = ("${geofenceModel.radius}");
      });
    });

    setState(() {});
    getCurrentPosition();

  }
  //update total device in the area
  Future updateTotalDevice(int totalDevice) async{

    final CollectionReference geofence = FirebaseFirestore.instance.collection('admin');

    return await geofence.doc('Geofence').update({'totalDevice':totalDevice});
  }

  //get current position for the geofencing
  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("LOCATION => ${position.toJson()}");
    isReady = (position != null) ? true : false;
    EasyGeofencing.startGeofenceService(
        pointedLatitude: latitude,
        pointedLongitude: longitude,
        radiusMeter: radius,
        eventPeriodInSeconds: 5
    );
    StreamSubscription<GeofenceStatus> geofenceStatusStream = EasyGeofencing.getGeofenceStream()!.listen(
            (GeofenceStatus status) {
          print(status.toString());
          print(latitude);
          checkStatus(status.toString());
        }
    );


  }
  //check status geofencing
  checkStatus(String Sts){
    if(Sts == "GeofenceStatus.enter")
    {
      FirebaseFirestore.instance.collection("users").doc(user!.uid).set(
          {
            "status" : "IN",
          },SetOptions(merge: true)).then((_)
      {
        print("Successfully Completed");
      }
      );
    }
    else if (Sts == "GeofenceStatus.exit")
    {
      FirebaseFirestore.instance.collection("users").doc(user!.uid).set(
          {
            "status" : "OUT",
          },SetOptions(merge: true)).then((_)
      {
        print("Successfully Completed");
      }
      );
    }
  }


  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    text: "Highlight".toUpperCase(),

                  ),
                  Tab(
                    text: "Stall List".toUpperCase(),
                  ),
                  Tab(
                    text: "Your Cart".toUpperCase(),
                  ),
                ],
                labelColor: Colors.white,
                indicator: DotIndicator(
                  color: Colors.white,
                  distanceFromCenter: 16,
                  radius: 3,
                  paintingStyle: PaintingStyle.fill,
                ),
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
              ),
               const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    highlighted(),
                    stallList(),
                    yourCart(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

