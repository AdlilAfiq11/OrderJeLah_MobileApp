
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fyp2/Admin/AdminNavigate/adminNavigate.dart';
import 'package:fyp2/Admin/noticeEditor/noticeCreator.dart';
import 'package:fyp2/Admin/subAnalysis/graphAnalysis.dart';
import 'package:fyp2/Admin/subAnalysis/stallNotice.dart';

class stallAnalysis extends StatefulWidget {
  const stallAnalysis({Key? key}) : super(key: key);

  @override
  State<stallAnalysis> createState() => _stallAnalysisState();
}

class _stallAnalysisState extends State<stallAnalysis> {

  CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const adminNavigate(),
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.blue,
        title: const Text('Food Stall Analysis'),
        centerTitle: true,
      ),
      body:  StreamBuilder(
        stream: ref.orderBy("stallName").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context, index) {
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  return Card(
                    child: SizedBox(
                        child: ListTile(
                          onTap: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => feedbackAnalysis(uid: documentSnapshot['uid'],)));
                          },
                          title: Text(documentSnapshot['ownerName']),
                          subtitle: Text(documentSnapshot['stallName']),
                          leading: const Image(
                              image: AssetImage('assets/images/logo.png')
                          ),
                        )
                    ),
                  );
                }
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class feedbackAnalysis extends StatefulWidget {
  String uid;
  feedbackAnalysis({Key? key, required this.uid }) : super(key: key);

  @override
  State<feedbackAnalysis> createState() => _feedbackAnalysisState();
}

class _feedbackAnalysisState extends State<feedbackAnalysis> {

  @override
  Widget build(BuildContext context) {
    final uid = widget.uid;
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback Analysis"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.blue,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spacing: 12,
          spaceBetweenChildren: 12,
          children:[
            SpeedDialChild(
              child: const Icon(Icons.add),
              backgroundColor: Colors.green,
              label: ("Create Notice"),
              onTap:  (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => createNotice(uid: uid)));
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.receipt),
              backgroundColor: Colors.orange,
              label: ("View Notice"),
              onTap:  (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => stallNotice(uid: uid)));
              },
            ),
          ],
        ),
      body: Center(
        child: graphAnalysis(uid: uid),
      )
    );
  }
}
