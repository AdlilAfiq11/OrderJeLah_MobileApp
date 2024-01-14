
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class stallNotice extends StatefulWidget {
  String uid;
  stallNotice({Key? key, required this.uid }) : super(key: key);

  @override
  State<stallNotice> createState() => _stallNoticeState();
}

class _stallNoticeState extends State<stallNotice> {

  @override
  Widget build(BuildContext context) {

    final uid = widget.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers/' + uid + '/StallNotice');

    return Scaffold(
      appBar: AppBar(title: const Text("Stall Notice"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
        body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {

                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final noticeID = documentSnapshot['noticeID'];
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
                            const SizedBox(height: 30),

                            ElevatedButton(
                                onPressed: (){
                                  deleteNotice(context, uid, noticeID);
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete Notice")),
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


Future<void> deleteNotice(BuildContext context, String uid, String noticeID) async {

  FirebaseFirestore.instance.collection('StallUsers').doc(uid).collection('StallNotice').doc(noticeID).delete();

  Fluttertoast.showToast(msg:"Successfully deleted the notice");
}