
import 'package:flutter/material.dart';
import 'package:fyp2/FoodStallOwner/subStallAnalysis/stallFeedback.dart';
import 'package:fyp2/FoodStallOwner/subStallAnalysis/stallNotice.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class stallAnalysis extends StatefulWidget {
  const stallAnalysis({Key? key}) : super(key: key);

  @override
  State<stallAnalysis> createState() => _stallAnalysisState();
}

class _stallAnalysisState extends State<stallAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TabBar(
                isScrollable: true,
                indicatorColor: Colors.red,
                tabs: [
                  Tab(
                    text: "Feedback".toUpperCase(),
                  ),
                  Tab(
                    text: "Notice".toUpperCase(),
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
                  horizontal:60,
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    viewStallFeedback(),
                    viewStallNotice(),
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
