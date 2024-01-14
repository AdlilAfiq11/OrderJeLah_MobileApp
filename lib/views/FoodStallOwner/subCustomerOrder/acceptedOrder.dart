
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/Models/Receipt.dart';
import 'package:fyp2/Models/geofence.dart';
import 'package:fyp2/Service/localPushNotification.dart';
import 'package:http/http.dart' as http;

class acceptedOrder extends StatefulWidget {
  const acceptedOrder({Key? key}) : super(key: key);

  @override
  State<acceptedOrder> createState() => _acceptedOrderState();
}

class _acceptedOrderState extends State<acceptedOrder> {

  User? user = FirebaseAuth.instance.currentUser;

  GeofenceModel geofence = GeofenceModel();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);

    });
    FirebaseFirestore.instance
        .collection('admin')
        .doc('Geofence')
        .get()
        .then((value) {
      geofence = GeofenceModel.fromMap(value.data());
      setState(() {});
    });
  }

  sendNotification(String title, String token)async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try{
      http.Response response = await  http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAlr2rBtk:APA91bGXiBSqu-pXPk0K6H92B7q4gN_BiC8YAVOWO0OyjnCkU7K77-iCuaj9FYSxGqWoiWMuveZUfEg2gc_XDCldBzt3ufzsCfKQg9aHfdAS_h8G-85NXc6WjAmZ8lLiYoWX6pcF2u1g'
      },
        body: jsonEncode(<String,dynamic>{
          'notification': <String,dynamic> {'title': title},
          'priority': 'high',
          'data': data,
          'to': token
        })
      );
      if(response.statusCode == 200){
        print("Yeh notificatin is sended");
      }else{
        print("Error");
      }
    }catch(e){}

  }


  @override
  Widget build(BuildContext context) {
    int totalDevice = int.parse("${geofence.totalDevice}");
    int limitDevice = int.parse("${geofence.limitDevice}");
    final CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/acceptedOrder');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Accepted Order'),
          centerTitle: true,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(totalDevice.toString()),
            ],
          ),
        ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String? token;
                  try{
                    token = snapshot.data!.docs[index]
                        .get('token');
                  }catch (e) {}

                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  final receiptID = documentSnapshot['receiptID'];
                  if (documentSnapshot['stallID'] == user?.uid) {
                    if(totalDevice>limitDevice){
                      return Card(
                        child: SizedBox(
                            child: ListTile(
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => orderDetails(receiptID: documentSnapshot['receiptID'], stallID: documentSnapshot['stallID'],)));
                              },
                              title: Text(documentSnapshot['custName']),
                              subtitle: Text(documentSnapshot['custPhone']),
                              leading: const Image(
                                  image: AssetImage('assets/images/order.png')
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      onPressed: (){
                                        Fluttertoast.showToast(msg:"Too many customer in the area.");
                                      },
                                      child: const Text("Pick Up")),
                                ],
                              ),
                            )
                        ),
                      );
                    }
                    else {
                      return Card(
                        child: SizedBox(
                            child: ListTile(
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => orderDetails(receiptID: documentSnapshot['receiptID'], stallID: documentSnapshot['stallID'],)));
                              },
                              title: Text(documentSnapshot['custName']),
                              subtitle: Text(documentSnapshot['custPhone']),
                              leading: const Image(
                                  image: AssetImage('assets/images/order.png')
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      onPressed: (){
                                        String status = "Pick Up";
                                        updateOrderStatus(receiptID, documentSnapshot['custID'], status);
                                        sendNotification('Pick Up Your Order', token!);
                                      },
                                      child: const Text("Pick Up")),
                                ],
                              ),
                            )
                        ),
                      );
                    }

                  }
                  return const Center();
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

Future<void> deleteProduct(String receiptID) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference del = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/acceptedOrder');

  await del.doc(receiptID).delete();
}

Future updateOrderStatus(String receiptID, String custID, String status) async{

  final CollectionReference order = FirebaseFirestore.instance.collection('users/' + custID + '/myOrder');

  return await order.doc(receiptID).update({'status': status} );
}


class orderDetails extends StatefulWidget {

  String receiptID, stallID;
  orderDetails({Key? key, required this.receiptID, required this.stallID}) : super(key: key);

  @override
  State<orderDetails> createState() => _orderDetailsState();
}

class _orderDetailsState extends State<orderDetails> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    final stallID = widget.stallID;
    final receiptID = widget.receiptID;

    DocumentReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/acceptedOrder').doc(receiptID);

    return Scaffold(
      appBar: AppBar(title: const Text("Customer Order"),
        centerTitle: true,
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
                          const Text("MENU NAME : " ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                            final docAccepted = FirebaseFirestore.instance.collection("StallUsers").doc(stallID).collection("completedOrder").doc(receiptID);
                            String status = "Completed";

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
                            Receipt.status = "Completed";
                            Receipt.totalPrice = (documentSnapshot['totalPrice']);

                            final json = Receipt.toJson()  ;
                            await docAccepted.set(json);

                            Fluttertoast.showToast(msg:"Successfully");
                            deleteProduct(receiptID);
                            updateOrderStatus(receiptID, documentSnapshot['custID'], status);
                          },
                              child: const Text('Completed Order'))
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

