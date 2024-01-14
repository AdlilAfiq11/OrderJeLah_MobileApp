
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/Models/feedback.dart';
import 'package:fyp2/Models/stallAnalysis.dart';


class custFeedback extends StatefulWidget {
  const custFeedback({Key? key}) : super(key: key);

  @override
  State<custFeedback> createState() => _custFeedbackState();
}

class _custFeedbackState extends State<custFeedback> {

  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers');

  int _value1 = 0;
  int _value2 = 0;
  int _value3 = 0;
  late String feedback1;
  late String feedbackValue1;
  late String feedback2;
  late String feedbackValue2;
  late String feedback3;
  late String feedbackValue3;

  var dropdownvalue;
  String feedback = "";
  String stallName = "";

  // late StreamSubscription _listener;
  int TotalCleanliness = 0;
  int TotalQuality = 0;
  int TotalServices = 0;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   _listener = FirebaseFirestore.instance
  //       .collection('StallUsers').doc(uid).collection('Feedback')
  //       .snapshots()
  //       .listen((snap) {
  //     final cases = snap.docs.map((doc) => doc.data());
  //
  //     for (var caseData in cases) {
  //       TotalCleanliness = TotalCleanliness + int.parse(caseData['CleanFeedbackValue']);
  //       TotalQuality = TotalQuality + int.parse(caseData['QualityFeedbackValue']);
  //       TotalServices = TotalServices + int.parse(caseData['ServiceFeedbackValue']);
  //
  //       updateAnalysis(uid, TotalCleanliness, TotalQuality, TotalServices);
  //     }
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _listener.cancel();
  //   super.dispose();
  // }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text("Customer Feedback"),
          centerTitle: true,
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Card(
                child: SizedBox(
                  child: ListBody(
                    children: <Widget>[
                      const SizedBox(height: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                         Text("Give your feedback on the scale provided" "\n""\n"
                             "(1) Not Satisfied " "\n" "\n"
                             "(2) Satisfied " + "\n" + "\n"
                             "(3) Very Satisfied " + "\n" + "\n"
                         ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child:
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('StallUsers')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Container();
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:30, right:30),
                        child: DropdownButton(
                          isExpanded: false,
                          items: snapshot.data?.docs.map((value) {
                            return DropdownMenuItem(
                              value: value.get('uid'),
                              child: Text('${value.get('stallName')}'),
                              onTap: (){
                                stallName = ('${value.get('stallName')}');
                              },
                            );
                          }).toList(),
                          onChanged: (value ,) {
                            print(value);
                            setState(
                                    () {
                                  dropdownvalue = value;
                                });
                          },
                          value: dropdownvalue,
                          hint: const Text('Food Stall                                             '),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: SizedBox(
                  child: ListBody(
                    children: <Widget>[

                      const SizedBox(height: 15),
                      const Text("(A) FOOD QUALITY"),
                      Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Radio(
                              value: 1,
                              groupValue: _value1,
                              onChanged: (value){
                                setState(() {
                                  _value1 = 1;
                                  feedback1 = "Not Satisfied";
                                  feedbackValue1 = "1";
                                });
                              },
                            ),
                            const Text("1"),
                              const SizedBox(height: 10.0),
                          ],),
                          Column(children: [
                            Radio(
                              value: 2,
                              groupValue: _value1,
                              onChanged: (value){
                                setState(() {
                                  _value1 = 2;
                                  feedback1 = "Satisfied";
                                  feedbackValue1 = "2";
                                });
                              },
                            ),
                            const Text("2"),
                            const SizedBox(height: 10.0),
                          ],),
                          Column(children: [
                            Radio(
                              value: 3,
                              groupValue: _value1,
                              onChanged: (value){
                                setState(() {
                                  _value1 = 3;
                                  feedback1 = "Very Satisfied";
                                  feedbackValue1 = "3";
                                });
                              },
                            ),
                            const Text("3"),
                            const SizedBox(height: 10.0),
                          ],),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  child: ListBody(
                    children: <Widget>[
                      const SizedBox(height: 15),
                      const Text("(B) PREMISE CLEANLINESS"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(children: [
                            Radio(
                              value: 1,
                              groupValue: _value2,
                              onChanged: (value){
                                setState(() {
                                  _value2 = 1;
                                  feedback2 = "Not Satisfied";
                                  feedbackValue2 = "1";
                                });
                              },
                            ),
                            const Text("1"),
                            const SizedBox(height: 10.0),
                          ],),
                          Column(children: [
                            Radio(
                              value: 2,
                              groupValue: _value2,
                              onChanged: (value){
                                setState(() {
                                  _value2 = 2;
                                  feedback2 = "Satisfied";
                                  feedbackValue2 = "2";
                                });
                              },
                            ),
                            const Text("2"),
                            const SizedBox(height: 10.0),
                          ],),
                          Column(children: [
                            Radio(
                              value: 3,
                              groupValue: _value2,
                              onChanged: (value){
                                setState(() {
                                  _value2 = 3;
                                  feedback2 = "Very Satisfied";
                                  feedbackValue2 = "3";
                                });
                              },
                            ),
                            const Text("3"),
                            const SizedBox(height: 10.0),
                          ],),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  child: ListBody(
                    children: <Widget>[
                      const SizedBox(height: 15),
                      const Text("(C) CUSTOMER SERVICE"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(children: [
                            Radio(
                              value: 1,
                              groupValue: _value3,
                              onChanged: (value){
                                setState(() {
                                  _value3 = 1;
                                  feedback3 = "Not Satisfied";
                                  feedbackValue3 = "1";
                                });
                              },
                            ),
                            const Text("1"),
                            const SizedBox(height: 10.0),
                          ],),
                          Column(children: [
                            Radio(
                              value: 2,
                              groupValue: _value3,
                              onChanged: (value){
                                setState(() {
                                  _value3 = 2;
                                  feedback3 = "Satisfied";
                                  feedbackValue3 = "2";
                                });
                              },
                            ),
                            const Text("2"),
                            const SizedBox(height: 10.0),
                          ],),
                          Column(children: [
                            Radio(
                              value: 3,
                              groupValue: _value3,
                              onChanged: (value){
                                setState(() {
                                  _value3 = 3;
                                  feedback3 = "Very Satisfied";
                                  feedbackValue3 = "3";
                                });
                              },
                            ),
                            const Text("3"),
                            const SizedBox(height: 10.0),
                          ],),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  child: ListBody(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      ElevatedButton(
                          onPressed: (){
                            final feedback = FeedbackModel(
                              stallName: stallName,
                              stallID: dropdownvalue,
                              QualityFeedback: feedback1,
                              QualityFeedbackValue: feedbackValue1,
                              CleanFeedback: feedback2,
                              CleanFeedbackValue: feedbackValue2,
                              ServiceFeedback: feedback3,
                              ServiceFeedbackValue: feedbackValue3,
                            );

                            final analysis = AnalysisModel(
                                totalValueCleanliness: TotalCleanliness,
                                totalValueQuality: TotalQuality,
                                totalValueServices: TotalServices,
                            );

                            final uid = dropdownvalue;
                            createFeedback(feedback, uid);
                            createAnalysis(analysis, uid);
                            Fluttertoast.showToast(msg:"Successfully");
                            Navigator.pop(context);
                          },
                          child: const Text("Submit"))
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

Future createFeedback(FeedbackModel feedback, uid) async {
  final docFeedback = FirebaseFirestore.instance.collection('StallUsers/' + uid + '/Feedback').doc();
  final docAnalysis = FirebaseFirestore.instance.collection('StallUsers/' + uid + '/Analysis').doc('Overall');
  feedback.feedbackID = docFeedback.id;

  final json = feedback.toJson();
  await docAnalysis.set(json);
  await docFeedback.set(json);
}


Future createAnalysis(AnalysisModel analysis, uid) async {
  final docAnalysis = FirebaseFirestore.instance.collection('StallUsers/' + uid + '/Analysis').doc('Overall');

  final json = analysis.toJson();
  await docAnalysis.set(json);
}
