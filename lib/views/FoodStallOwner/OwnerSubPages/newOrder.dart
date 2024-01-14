import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/FoodStallOwner/OwnerNavigate/StallNavigation.dart';
import 'package:fyp2/Models/Receipt.dart';

class newOrder extends StatefulWidget {
  const newOrder({Key? key}) : super(key: key);

  @override
  State<newOrder> createState() => _newOrderState();
}

class _newOrderState extends State<newOrder> {

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("StallUsers").doc(user!.uid).collection("NewOrder").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context, index){
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  return Center(
                    child: Dialog(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.pink,
                                child: const Icon(Icons.doorbell_rounded, size: 100, color: Colors.white),
                              ),
                            ),
                            Expanded(
                                child: Container(
                                  color: Colors.pinkAccent,
                                  child: SizedBox.expand(
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        children: [
                                          RaisedButton(
                                            color: Colors.white,
                                            child: const Text('Customer Order Coming !!'),
                                            onPressed: ()=> {
                                              Navigator.push(
                                                  context, MaterialPageRoute(builder: (context) => custOrderDetails(receiptID: documentSnapshot['receiptID'])))
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }
          return const Center(
            child: Text("No Order"),
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

    final receiptID = widget.receiptID;

    DocumentReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/NewOrder').doc(receiptID);

    return Scaffold(
      appBar: AppBar(title: const Text("Customer Order"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<dynamic>(
        stream: ref.snapshots(),
        builder: (BuildContext context, snapshot){
          if(snapshot.hasData && snapshot.data.exists){
            Map<String, dynamic> documentSnapshot = snapshot.data!.data();
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
                          const Text("CUSTOMER PHONE :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                          Text("\n""RM : " + documentSnapshot['totalPrice'].toString(), textAlign: TextAlign.center),

                          const SizedBox(height: 25),
                          const Text("ORDER STATUS :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['status'] + "\n", textAlign: TextAlign.center),

                          ElevatedButton(onPressed: () async {

                            final docAccepted = FirebaseFirestore.instance.collection("StallUsers").doc(user!.uid).collection("acceptedOrder").doc(receiptID);
                            String status = "Accepted";

                            ReceiptModel Receipt = ReceiptModel();

                            Receipt.receiptID = documentSnapshot['receiptID'];
                            Receipt.menuID = documentSnapshot['menuID'];
                            Receipt.stallID = documentSnapshot['stallID'];
                            Receipt.custID = documentSnapshot['custID'];
                            Receipt.menuName = documentSnapshot['menuName'];
                            Receipt.menuPrice = documentSnapshot['menuPrice'];
                            Receipt.stallName = documentSnapshot['stallName'];
                            Receipt.quantity = (documentSnapshot['quantity']);
                            Receipt.custName = (documentSnapshot['custName']);
                            Receipt.custPhone = (documentSnapshot['custPhone']);
                            Receipt.token = (documentSnapshot['token']);
                            Receipt.status = status;
                            Receipt.totalPrice = (documentSnapshot['totalPrice']);
                            final json = Receipt.toJson();
                            await docAccepted.set(json);

                            Fluttertoast.showToast(msg:"Successfully");
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  const OwnerPagesNavigate()));
                            deleteProduct(receiptID);
                            updateOrderStatus(receiptID,documentSnapshot['custID'],status);
                          },
                              child: const Text('Accept Order'),),

                          ElevatedButton(onPressed: ( ) async {
                            final docRejected = FirebaseFirestore.instance.collection("StallUsers").doc(user!.uid).collection("rejectedOrder").doc(receiptID);

                            String status = "Rejected";
                            String reason = "Rejected Due To The Some Problem Happens";
                            ReceiptModel Receipt = ReceiptModel();

                            Receipt.receiptID = documentSnapshot['receiptID'];
                            Receipt.menuID = documentSnapshot['menuID'];
                            Receipt.stallID = documentSnapshot['stallID'];
                            Receipt.custID = documentSnapshot['custID'];
                            Receipt.menuName = documentSnapshot['menuName'];
                            Receipt.menuPrice = documentSnapshot['menuPrice'];
                            Receipt.stallName = documentSnapshot['stallName'];
                            Receipt.quantity = (documentSnapshot['quantity']);
                            Receipt.custName = (documentSnapshot['custName']);
                            Receipt.custPhone = (documentSnapshot['custPhone']);
                            Receipt.status = status;
                            Receipt.rejectedReason = reason;
                            Receipt.totalPrice = (documentSnapshot['totalPrice']);

                            final json = Receipt.toJson()  ;
                            await docRejected.set(json);

                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const OwnerPagesNavigate()));

                            deleteProduct(receiptID);
                            updateOrderStatus(receiptID,documentSnapshot['custID'],status);
                            updateOrderInfo(receiptID,documentSnapshot['custID'],reason);
                          },
                              child: const Text('Reject Order'))
                        ],
                      )
                  ),
                ),
              ],
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



Future<void> deleteProduct(String receiptID) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference del = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/NewOrder');

  await del.doc(receiptID).delete();
}

Future updateOrderStatus(String receiptID, String custID, String status) async{

  final CollectionReference order = FirebaseFirestore.instance.collection('users/' + custID + '/myOrder');

  return await order.doc(receiptID).update({'status': status});
}

Future updateOrderInfo(String receiptID, String custID, String reason) async{

  final CollectionReference order = FirebaseFirestore.instance.collection('users/' + custID + '/myOrder');

  return await order.doc(receiptID).update({'rejectedReason': reason});
}
