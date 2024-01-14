// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:fyp2/GeneralUser/Geofence/subGeofence/geoEngine.dart';
// import 'package:fyp2/GeneralUser/Geofence/subGeofence/geoStatus.dart';
// import 'package:geolocator/geolocator.dart';
//
//
// class Geofencing extends StatefulWidget {
//   const Geofencing({Key? key}) : super(key: key);
//
//   @override
//   State<Geofencing> createState() => _GeofencingState();
// }
//
// class _GeofencingState extends State<Geofencing> {
//
//   late StreamSubscription<GeofenceStatus> geofenceStatusStream;
//   Geolocator geolocator = Geolocator();
//   String geofenceStatus = '';
//   bool isReady = false;
//   late Position position;
//
//   getCurrentPosition() async {
//     position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print("LOCATION => ${position.toJson()}");
//     isReady = (position != null) ? true : false;
//     EasyGeofencing.startGeofenceService(
//         pointedLatitude: "2.2276356",
//         pointedLongitude: "102.4568397",
//         radiusMeter: "6",
//         eventPeriodInSeconds: 5
//
//     );
//     StreamSubscription<GeofenceStatus> geofenceStatusStream = EasyGeofencing.getGeofenceStream()!.listen(
//             (GeofenceStatus status) {
//           print(status.toString());
//         });
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
//
//
