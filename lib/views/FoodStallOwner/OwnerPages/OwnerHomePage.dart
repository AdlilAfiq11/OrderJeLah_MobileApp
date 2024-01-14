import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/FoodStallOwner/OwnerSubPages/newOrder.dart';
import 'package:fyp2/FoodStallOwner/OwnerSubPages/customerOrder.dart';
import 'package:fyp2/FoodStallOwner/OwnerSubPages/menuEditor.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';


class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({Key? key}) : super(key: key);

  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {

  User? user = FirebaseAuth.instance.currentUser;

  late StreamSubscription _listener;
  int TotalCleanliness = 0;
  int TotalQuality = 0;
  int TotalServices = 0;

  @override
  void initState() {
    super.initState();

    _listener = FirebaseFirestore.instance
        .collection('StallUsers').doc(user!.uid).collection('Feedback')
        .snapshots()
        .listen((snap) {
      final cases = snap.docs.map((doc) => doc.data());

      for (var caseData in cases) {
        TotalCleanliness = TotalCleanliness + int.parse(caseData['CleanFeedbackValue']);
        TotalQuality = TotalQuality + int.parse(caseData['QualityFeedbackValue']);
        TotalServices = TotalServices + int.parse(caseData['ServiceFeedbackValue']);

        updateAnalysis(TotalCleanliness, TotalQuality, TotalServices);
        print(TotalCleanliness);
      }
    });
  }


  Future updateAnalysis(int TotalCleanliness, int TotalQuality, int TotalServices) async{

    User? user = FirebaseAuth.instance.currentUser;

    final CollectionReference analysis = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/Analysis');

    return await analysis.doc('Overall').update({'totalValueCleanliness':TotalCleanliness, 'totalValueQuality':TotalQuality, 'totalValueServices':TotalServices} );
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
                indicatorColor: Colors.red,
                tabs: [
                  Tab(
                    text: "New Order".toUpperCase(),
                  ),
                  Tab(
                    text: "Customer Order".toUpperCase(),
                  ),
                  Tab(
                    text: "Menu Editor".toUpperCase(),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    newOrder(),
                    OrderList(),
                    MenuEditor(),
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

