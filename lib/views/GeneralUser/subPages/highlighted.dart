import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/GeneralUser/UserNavigate/navigation.dart';
import 'package:fyp2/Models/Cart.dart';


class highlighted extends StatelessWidget {
  const highlighted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('HighlightedMenu').orderBy("stallName").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context, index){
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  return Card(
                    color: Colors.amber,
                    shadowColor: Colors.black,
                    child: SizedBox(
                        child: ListTile(
                          onTap: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => highlightedDetails(highlightID: documentSnapshot['highlightID'])));
                          },
                          title: Text(documentSnapshot['menuName']),
                          subtitle: Text(documentSnapshot['stallName']),
                          leading: const Image(
                              image: AssetImage('assets/images/rating.png')
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



class highlightedDetails extends StatefulWidget {

  String highlightID;
  highlightedDetails({Key? key, required this.highlightID}) : super(key: key);

  @override
  State<highlightedDetails> createState() => _highlightedDetailsState();
}

class _highlightedDetailsState extends State<highlightedDetails> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    DocumentReference ref = FirebaseFirestore.instance.collection('HighlightedMenu').doc(widget.highlightID);

    return Scaffold(
      appBar: AppBar(title: const Text("Highlighted "),
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
                          const Text("MENU NAME" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['menuName'], textAlign: TextAlign.center),

                          const SizedBox(height: 25),
                          const Text("MENU PRICE " ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['menuPrice'], textAlign: TextAlign.center),

                          const SizedBox(height: 25),
                          const Text("STALL NAME " ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['stallName'] + "\n", textAlign: TextAlign.center),

                          const SizedBox(height: 30),
                          ElevatedButton(onPressed:() async{
                            final docCart = FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("Cart").doc(widget.highlightID);

                            CartModel Cart = CartModel();

                            Cart.highlightedID = widget.highlightID;
                            Cart.menuID = documentSnapshot['menuID'];
                            Cart.stallID = documentSnapshot['stallID'];
                            Cart.menuName = documentSnapshot['menuName'];
                            Cart.menuPrice = documentSnapshot['menuPrice'];
                            Cart.stallName = documentSnapshot['stallName'];
                            Cart.custID = user?.uid;
                            Cart.quantity = "1";

                            final json = Cart.toJson();
                            await docCart.set(json);

                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const PagesNavigate()));

                            Fluttertoast.showToast(msg:"Added To Cart");
                          }, child: const Text('Add To Cart'))
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
