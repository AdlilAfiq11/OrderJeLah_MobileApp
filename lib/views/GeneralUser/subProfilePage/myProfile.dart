import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/GeneralUser/UserNavigate/navigation.dart';
import 'package:fyp2/Models/users.dart';



class myProfile extends StatefulWidget {
  const myProfile({Key? key}) : super(key: key);

  @override
  State<myProfile> createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {

  String userID = FirebaseAuth.instance.currentUser!.uid;

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser = UserModel();

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account Information"),
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
                        subtitle: Text ("${loggedInUser.name}"),
                        trailing: IconButton(icon: const Icon(Icons.edit_sharp),
                          onPressed:()  => bottomProfileNameEditor(context)
                          ,)

                    ),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text("Phone Number"),
                        subtitle: Text ("${loggedInUser.phone}"),
                        trailing: IconButton(icon: const Icon(Icons.edit_sharp),
                          onPressed:()  => bottomProfilePhoneEditor(context)
                          ,)
                    ),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text("Email"),
                        subtitle: Text ("${loggedInUser.email}"),
                    ),
                  ),
                ],
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
              ),
            ],
          ) //Padding
      ),
    );
  }

  void bottomProfileNameEditor(BuildContext e){

    final TextEditingController _nameController = TextEditingController();

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
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () {
                nameUpdate(_nameController.text,  userID);
                Fluttertoast.showToast(msg:"Successfully");
                Navigator.pop(context);
              }, child: const Text('Submit'))
            ],
          ),
        ));
  }
  void bottomProfilePhoneEditor(BuildContext e){

    final TextEditingController _phoneController = TextEditingController();

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
                controller:  _phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () {
                phoneUpdate(_phoneController.text,  userID);
                Fluttertoast.showToast(msg:"Successfully");
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const PagesNavigate()));
              }, child: const Text('Submit'))
            ],
          ),
        ));
  }
}



Future nameUpdate(String name, String userID) async{

  final CollectionReference profile = FirebaseFirestore.instance.collection('users');

  return await profile.doc(userID).update({'name': name});

}
Future phoneUpdate( String phone, String userID) async{

  final CollectionReference profile = FirebaseFirestore.instance.collection('users');

  return await profile.doc(userID).update({ 'phone' : phone} );

}
