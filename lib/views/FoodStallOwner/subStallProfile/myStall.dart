import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/Models/StallUsers.dart';

class myStall extends StatefulWidget {
  const myStall({Key? key}) : super(key: key);

  @override
  State<myStall> createState() => _myStallState();
}

class _myStallState extends State<myStall> {

  String UserID = FirebaseAuth.instance.currentUser!.uid;
  User? user = FirebaseAuth.instance.currentUser;
  StallUsers loggedInUser = StallUsers();

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection("StallUsers")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = StallUsers.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    String status = ("${loggedInUser.stallStatus}");

    return Scaffold(
      appBar: AppBar(title: const Text("Stall Profile"),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
            children:<Widget> [
              ListView(
                children: [
                  Card(
                    child:ListTile(
                        title: const Text("Full Name"),
                        subtitle: Text ("${loggedInUser.ownerName}"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text("Phone Number"),
                        subtitle: Text ("${loggedInUser.ownerPhone}"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Email"),
                      subtitle: Text ("${loggedInUser.email}"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Stall Name"),
                      subtitle: Text ("${loggedInUser.stallName}"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Stall Status"),
                      subtitle: Text ("${loggedInUser.stallStatus}"),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () => userUpdateStallStatus(UserID, status),
                              child: const Text('Change Status'))
                        ],
                      ),
                    ),
                  ),
                ],
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
              ),
            ],
          )
      ),
    );
  }
  Future userUpdateStallStatus(String UserID, String stallStatus) async{

    final CollectionReference status = FirebaseFirestore.instance.collection('StallUsers');

    if(stallStatus == "Open"){
      stallStatus = "Closed";
    }
    else{
      stallStatus = "Open";
    }
    Navigator.pop(context);
    return await status.doc(UserID).update({'stallStatus':stallStatus} );

  }

}
