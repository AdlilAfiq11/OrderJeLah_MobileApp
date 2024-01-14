
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class viewStallFeedback extends StatefulWidget {
  const viewStallFeedback({Key? key}) : super(key: key);

  @override
  State<viewStallFeedback> createState() => _viewStallFeedbackState();
}

class _viewStallFeedbackState extends State<viewStallFeedback> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/Feedback');

    return Scaffold(
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {

                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(30),
                  child: PhysicalModel(
                    color: Colors.orange.shade300,
                    elevation: 20,
                    shadowColor: Colors.black,

                    child: ListBody(
                      children: <Widget>[

                        const SizedBox(height: 45),

                        const Center(
                          child: Text("Customer Feedback",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("\n"+ " Food Stall Cleanliness " + " : "+documentSnapshot['CleanFeedback'], textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        Text("\n"+ " Food Quality " + " : "+documentSnapshot['QualityFeedback'], textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        Text("\n"+ " Customer Service " + " : "+documentSnapshot['ServiceFeedback'], textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
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
