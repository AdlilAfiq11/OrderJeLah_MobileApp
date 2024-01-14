import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/Models/Cart.dart';
import 'package:fyp2/Models/Receipt.dart';
import 'package:fyp2/Models/users.dart';
import 'package:pay/pay.dart';

class yourCart extends StatefulWidget {

  const yourCart({Key? key}) : super(key: key);

  @override
  State<yourCart> createState() => _yourCartState();
}

class _yourCartState extends State<yourCart> {

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser = UserModel();

  late StreamSubscription _listener;
  double TotalPrice = 0;
  @override
  void initState() {
    super.initState();

    _listener = FirebaseFirestore.instance
        .collection('users').doc(user!.uid).collection('Cart')
        .snapshots()
        .listen((snap) {
      final cases = snap.docs.map((doc) => doc.data());

      TotalPrice = 0;
      for (var caseData in cases) {
        TotalPrice = double.parse(caseData['menuPrice']) * int.parse(caseData['quantity']);
      }

      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final custName = ("${loggedInUser.name}");
    final custPhone = ("${loggedInUser.phone}");
    final userToken = ("${loggedInUser.token}");
    final CollectionReference ref = FirebaseFirestore.instance.collection('users/' + user!.uid + '/Cart');

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context, index){
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  final menuID = documentSnapshot['menuID'];
                  final stallID = documentSnapshot['stallID'];
                    return Card(
                      color: Colors.white70,
                      child: SizedBox(
                          child: ListTile(
                            title: Text(documentSnapshot['menuName']),
                            subtitle: Text(documentSnapshot['stallName']),
                            leading: const Image(
                                image: AssetImage('assets/images/order.png')
                            ),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context) => orderEdit(menuID: documentSnapshot['menuID'],TotalPrice:TotalPrice)));
                                  },
                                ),
                                ElevatedButton(onPressed: ()  async {

                                  await Navigator.push(
                                      context, MaterialPageRoute(builder: (context) =>  const payment()));
                                  Fluttertoast.showToast(msg:"Payment Successfully");

                                  final docCart = FirebaseFirestore.instance.collection("StallUsers").doc(stallID).collection("NewOrder").doc();

                                  ReceiptModel receiptModel = ReceiptModel();

                                  receiptModel.menuID = documentSnapshot['menuID'];
                                  receiptModel.highlightedID = documentSnapshot['highlightedID'];
                                  receiptModel.stallID = documentSnapshot['stallID'];
                                  receiptModel.menuName = documentSnapshot['menuName'];
                                  receiptModel.menuPrice = documentSnapshot['menuPrice'];
                                  receiptModel.stallName = documentSnapshot['stallName'];
                                  receiptModel.quantity = documentSnapshot['quantity'];
                                  receiptModel.custID = documentSnapshot['custID'];
                                  receiptModel.totalPrice = '$TotalPrice';
                                  receiptModel.custName = custName;
                                  receiptModel.custPhone = custPhone;
                                  receiptModel.token = userToken;
                                  receiptModel.status = "Pending";
                                  receiptModel.receiptID = docCart.id;

                                  final rID = receiptModel.receiptID;
                                  final docCustOrder = FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("myOrder").doc(rID);

                                  final json = receiptModel.toJson();
                                  await docCart.set(json);
                                  await docCustOrder.set(json);

                                  Fluttertoast.showToast(msg:"Successfully send your order");

                                  deleteProduct(menuID);

                                },
                                    child: const Text('Check Out'))
                              ],
                            ),
                          )
                      ),
                    );
                  }
            );
          }
          return const Center(
            child: Image(
                image: AssetImage('assets/images/emptyCart.png')),
          );
        },
      ),
    );
  }
}

Future<void> deleteProduct(String menuID) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference del = FirebaseFirestore.instance.collection('users/' + user!.uid + '/Cart');

  await del.doc(menuID).delete();
}



//Edit selected menu
class orderEdit extends StatefulWidget {

  String menuID;
  double TotalPrice;
  orderEdit({Key? key, required this.menuID, required this.TotalPrice}) : super(key: key);

  @override
  State<orderEdit> createState() => _orderEditState();
}

class _orderEditState extends State<orderEdit> {

  User? user = FirebaseAuth.instance.currentUser;
  dynamic data;


  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String menuID = widget.menuID;
    DocumentReference ref = FirebaseFirestore.instance.collection('users/' + user!.uid + '/Cart').doc(menuID);
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart"),
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
                          const Text("MENU NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['menuName'], textAlign: TextAlign.center),

                          const SizedBox(height: 25),
                          const Text("MENU PRICE :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n" "RM : " + documentSnapshot['menuPrice'] + "\n", textAlign: TextAlign.center),

                          const SizedBox(height: 10),
                          const Text("QUANTITY :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['quantity'], textAlign: TextAlign.center),
                          IconButton(onPressed: ()
                          => menuQuantityEditor(context, menuID)
                              , icon: const Icon(Icons.edit)),
                          const SizedBox(height: 10),
                          const Text("TOTAL PRICE :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"  "RM : " + documentSnapshot['totalPrice'].toString()+ "\n", textAlign: TextAlign.center),

                          const SizedBox(height: 10),
                          ElevatedButton(onPressed:() => deleteProduct(menuID), child: const Text('Delete'))
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

  void menuQuantityEditor(BuildContext e, String menuID){

    final TextEditingController _menuQuantityController = TextEditingController();

    showModalBottomSheet(
        isScrollControlled:true,
        context: e,
        builder: (e) => Padding
          (padding: EdgeInsets.only(
            top:15,
            left:15,
            right:15,
            bottom: MediaQuery.of(e).viewInsets.bottom +15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _menuQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () async {

                double TotalPrice=0.00;

                await userUpdateOrderQuantity(_menuQuantityController.text, menuID);
                final DocumentReference ref = FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("Cart").doc(menuID);
                await ref.get().then<dynamic>((DocumentSnapshot snapshot) async{
                  setState(() {
                    data = snapshot.data();
                    TotalPrice = double.parse(data['menuPrice']) * int.parse(data['quantity']);
                  });
                });
                await ref.update({'totalPrice' : TotalPrice});
                Fluttertoast.showToast(msg:"Successfully");
                Navigator.pop(context);
              }, child: const Text('Submit'))
            ],
          ),
        ));
  }

}

Future userUpdateOrderQuantity(String quantity, String menuID) async{

  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference order = FirebaseFirestore.instance.collection('users/' + user!.uid + '/Cart');

  await order.doc(menuID).update({'quantity':quantity} );
}



//payment
class payment extends StatefulWidget {
  const payment({Key? key}) : super(key: key);

  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> {


  User? user = FirebaseAuth.instance.currentUser;
  CartModel cartModel = CartModel();

  final _paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];
  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  void initState() {
    super.initState();

      FirebaseFirestore.instance
          .collection('users/' + user!.uid + '/Cart')
          .doc(user!.uid)
          .get()
          .then((value) {
        cartModel = CartModel.fromMap(value.data());
        setState(() {});
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.teal,
        title: const Text('OrderJeLah!'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GooglePayButton(
              width: 300,
              paymentConfigurationAsset: 'Gpay.json',
              paymentItems: _paymentItems,
              style: GooglePayButtonStyle.black,
              type: GooglePayButtonType.pay,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: onGooglePayResult,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

