

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class completedOrder extends StatefulWidget {
  const completedOrder({Key? key}) : super(key: key);

  @override
  State<completedOrder> createState() => _completedOrderState();
}

class _completedOrderState extends State<completedOrder> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    final CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/completedOrder');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Order'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  if (documentSnapshot['stallID'] == user?.uid) {
                    return Card(
                      child: SizedBox(
                          child: ListTile(
                            onTap: (){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => orderDetails(receiptID: documentSnapshot['receiptID'])));
                            },
                            title: Text(documentSnapshot['custName']),
                            subtitle: Text(documentSnapshot['custPhone']),
                            leading: const Image(
                                image: AssetImage('assets/images/order.png')
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                IconButton(icon: Icon(Icons.done_all_outlined),
                                  onPressed: null,
                                  color: Colors.blue,
                                ),
                              ],
                            ),

                          )
                      ),
                    );
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


class orderDetails extends StatefulWidget {

  String receiptID;
  orderDetails({Key? key, required this.receiptID}) : super(key: key);

  @override
  State<orderDetails> createState() => _orderDetailsState();
}

class _orderDetailsState extends State<orderDetails> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    DocumentReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/completedOrder').doc(widget.receiptID);

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
