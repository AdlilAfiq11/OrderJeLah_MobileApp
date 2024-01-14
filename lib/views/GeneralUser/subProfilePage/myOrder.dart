import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class myOrder extends StatelessWidget {
  myOrder({Key? key}) : super(key: key);

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Order "),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("myOrder").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context, index){
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  return Card(
                    child: SizedBox(
                        child: ListTile(
                          onTap: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => custOrderDetails(receiptID: documentSnapshot['receiptID'])));
                          },
                          title: Text(documentSnapshot['menuName']),
                          subtitle: Text(documentSnapshot['stallName']),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ElevatedButton(onPressed: (){},
                                  child: Text("Status:   " + documentSnapshot['status']))
                            ],
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

class custOrderDetails extends StatefulWidget {
  String receiptID;
  custOrderDetails({Key? key, required this.receiptID}) : super(key: key);

  @override
  State<custOrderDetails> createState() => _custOrderDetailsState();
}

class _custOrderDetailsState extends State<custOrderDetails> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    DocumentReference ref = FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("myOrder").doc(widget.receiptID);

    return Scaffold(
      appBar: AppBar(title: const Text("Customer Order "),
        centerTitle: true,
      ),
      body: StreamBuilder<dynamic>(
        stream: ref.snapshots(),
        builder: (BuildContext context, snapshot){
          if(snapshot.hasData && snapshot.data.exists){
            Map<String, dynamic> documentSnapshot = snapshot.data!.data();
            if(documentSnapshot['status'] == "Rejected"){
              return ListView(
                children: [
                  Card(
                    child: SizedBox(
                        child: ListBody(
                          children: [
                            const SizedBox(height: 25),
                            const Text("CUSTOMER NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['custName'], textAlign: TextAlign.center),

                            const SizedBox(height: 25),
                            const Text("STUDENT PHONE :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['custPhone'], textAlign: TextAlign.center),

                            const SizedBox(height: 25),
                            const Text("STALL NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['stallName'] + "\n", textAlign: TextAlign.center),

                            const SizedBox(height: 15),
                            const Text("MENU NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['menuName'], textAlign: TextAlign.center),

                            const SizedBox(height: 25),
                            const Text("ORDER QUANTITY :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['quantity'], textAlign: TextAlign.center),

                            const SizedBox(height: 25),
                            const Text("TOTAL PRICE :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n RM "+documentSnapshot['totalPrice'].toString() + "\n", textAlign: TextAlign.center),

                            const SizedBox(height: 15),
                            const Text("ORDER STATUS :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['status'] + "\n", textAlign: TextAlign.center),

                            const SizedBox(height: 15),
                            const Text("REJECTED REASON : " ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['rejectedReason'] + "\n", textAlign: TextAlign.center),
                          ],
                        )
                    ),
                  ),
                ],
              );
            }
            else {
              return ListView(
                children: [
                  Card(
                    child: SizedBox(
                        child: ListBody(
                          children: [
                            const SizedBox(height: 25),
                            const Text("CUSTOMER NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['custName'], textAlign: TextAlign.center),

                            const SizedBox(height: 25),
                            const Text("STUDENT PHONE :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['custPhone'], textAlign: TextAlign.center),

                            const SizedBox(height: 25),
                            const Text("STALL NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['stallName'] + "\n", textAlign: TextAlign.center),

                            const SizedBox(height: 15),
                            const Text("MENU NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['menuName'], textAlign: TextAlign.center),

                            const SizedBox(height: 25),
                            const Text("ORDER QUANTITY :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['quantity'], textAlign: TextAlign.center),

                            const SizedBox(height: 25),
                            const Text("TOTAL PRICE :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n RM "+documentSnapshot['totalPrice'].toString() + "\n", textAlign: TextAlign.center),

                            const SizedBox(height: 15),
                            const Text("ORDER STATUS :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text("\n"+documentSnapshot['status'] + "\n", textAlign: TextAlign.center),
                          ],
                        )
                    ),
                  ),
                ],
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
