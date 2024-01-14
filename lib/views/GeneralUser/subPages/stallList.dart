
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/GeneralUser/subPages/feedbackCreator.dart';
import 'package:fyp2/Models/Cart.dart';


//display list of stall
class stallList extends StatefulWidget {
  const stallList({Key? key}) : super(key: key);

  @override
  State<stallList> createState() => _stallListState();
}

class _stallListState extends State<stallList> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const custFeedback()));
      },
        icon :const Icon(Icons.add),
        label: const Text('Create Feedback'),
      ),
      backgroundColor: Colors.white,
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('StallUsers').orderBy("stallName").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context, index){
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  if(documentSnapshot['stallStatus'] == "Open"){
                    return Card(
                      color: Colors.white70,
                      child: SizedBox(
                          child: ListTile(
                            onTap: (){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => stallMenu(uid: documentSnapshot['uid'], stallName: documentSnapshot['stallName'])));
                            },
                            title: Text(documentSnapshot['stallName']),
                            subtitle: Text(documentSnapshot['stallStatus']),
                            leading: const Image(
                                image: AssetImage('assets/images/logo.png')
                            ),
                          )
                      ),
                    );
                  }
                  else {
                    return Card(
                      color: Colors.red,
                      child: SizedBox(
                          child: ListTile(
                            onTap: (){
                              Fluttertoast.showToast(msg:"The stall is not available");
                            },
                            title: Text(documentSnapshot['stallName']),
                            subtitle: Text(documentSnapshot['stallStatus']),
                            leading: const Image(
                                image: AssetImage('assets/images/logo.png')
                            ),
                          )
                      ),
                    );
                  }
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


//display menu for selected stall
class stallMenu extends StatefulWidget {

  String uid, stallName;
  stallMenu({Key? key, required this.uid, required this.stallName}) : super(key: key);

  @override
  State<stallMenu> createState() => _stallMenuState();
}

class _stallMenuState extends State<stallMenu> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String stallID = widget.uid;
    String stallName = widget.stallName;
    final CollectionReference ref = FirebaseFirestore.instance.collection(('StallUsers/' + stallID + '/StallMenu'));
    return Scaffold(
      appBar: AppBar(title: const Text("List of Menu"),
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
                  final menuID = documentSnapshot['menuID'];
                  if(documentSnapshot['menuStatus'] == "Active"){
                    return Card(
                      color: Colors.white70,
                      shadowColor: Colors.black,
                      child: SizedBox(
                          child: ListTile(
                            title: Text(documentSnapshot['menuName']),
                            subtitle: Text(documentSnapshot['menuPrice']),
                            leading: const Image(
                                image: AssetImage('assets/images/restaurant.png')
                            ),
                            trailing: IconButton(icon: const Icon(Icons.add_shopping_cart),
                              onPressed: () async {
                                final docCart = FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("Cart").doc(menuID);

                                CartModel Cart = CartModel();

                                Cart.menuID = documentSnapshot['menuID'];
                                Cart.stallID = documentSnapshot['stallID'];
                                Cart.menuName = documentSnapshot['menuName'];
                                Cart.menuPrice = documentSnapshot['menuPrice'];
                                Cart.menuType = documentSnapshot['menuType'];
                                Cart.stallName = stallName;
                                Cart.totalPrice = documentSnapshot['menuPrice'];
                                Cart.custID = user?.uid;
                                Cart.quantity = "1";

                                final json = Cart.toJson()  ;
                                await docCart.set(json);

                                Fluttertoast.showToast(msg:"Added To Cart");
                              },
                            ),
                          )
                      ),
                    );
                  }
                  else{
                    return Card(
                      color: Colors.red,
                      child: SizedBox(
                          child: ListTile(
                            onTap: null,
                            title: Text(documentSnapshot['menuName']),
                            subtitle: Text(documentSnapshot['menuPrice']),
                            leading: const Image(
                                image: AssetImage('assets/images/restaurant.png')
                            ),
                            trailing: IconButton(icon: const Icon(Icons.add_shopping_cart),
                              onPressed: () async {
                                Fluttertoast.showToast(msg:"The menu is not available");
                              },
                            ),
                          )
                      ),
                    );
                  }
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




