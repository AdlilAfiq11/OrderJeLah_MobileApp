
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class viewStallNotice extends StatefulWidget {
  const viewStallNotice({Key? key}) : super(key: key);

  @override
  State<viewStallNotice> createState() => _viewStallNoticeState();
}

class _viewStallNoticeState extends State<viewStallNotice> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/StallNotice');

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
                          child: Text("Notice From Admin !!",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("\n"+documentSnapshot['noticeDate'], textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        Text("\n"+documentSnapshot['noticeText'], textAlign: TextAlign.center),
                        const SizedBox(height: 40),

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
