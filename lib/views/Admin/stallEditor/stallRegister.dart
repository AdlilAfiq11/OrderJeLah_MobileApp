
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/Admin/Pages/ListStall.dart';
import 'package:fyp2/Models/StallUsers.dart';


class registerStall extends StatefulWidget {
  const registerStall({Key? key}) : super(key: key);

  @override
  State<registerStall> createState() => _registerStallState();

}

class _registerStallState extends State<registerStall> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController stallNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String category = "Seller";
  String status = "default";

  postDetailsToFirestore() async{
    //calling Firestore
    //calling user model
    //sending value
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    StallUsers stallUsers = StallUsers();

    stallUsers.email = user!.email;
    stallUsers.ownerName = nameController.text;
    stallUsers.ownerPhone = phoneController.text;
    stallUsers.stallName = stallNameController.text;
    stallUsers.stallStatus = status;
    stallUsers.category = category;
    stallUsers.uid = user.uid;

    await firebaseFirestore
        .collection("StallUsers")
        .doc(user.uid)
        .set(stallUsers.toMap());

    Fluttertoast.showToast(msg:"New Food Stall Created Successfully");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => const ListStall()), (route) => false);
  }


  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text(""),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:  Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: screenHeight * .035),
                const Text(
                  "Create Food Stall",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: screenHeight * .055),
                TextFormField(
                  autofocus: true,
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("name is required.");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nameController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Enter Seller Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: screenHeight * .025),
                TextFormField(
                  autofocus: true,
                  controller: stallNameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("name is required.");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    stallNameController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Enter Stall Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: screenHeight * .025),
                TextFormField(
                  autofocus: true,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{10,}$');
                    if (value!.isEmpty) {
                      return ("Phone number is required.");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Please enter a valid phone number.");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phoneController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Enter Seller Phone Number",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: screenHeight * .025),
                TextFormField(
                  autofocus: true,
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    RegExp regex = RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                    if (value!.isEmpty) {
                      return ("Email is required.");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Please enter a valid email.");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Enter Seller Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: screenHeight * .025),
                TextFormField(
                  autofocus: false,
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return ("Password is required.");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Please enter a valid password.");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    passwordController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Enter Seller Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: screenHeight * .025),
                TextFormField(
                  autofocus: false,
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return ("Password is required.");
                    }
                    if (confirmPasswordController.text != passwordController.text) {
                      return ("Password does not match.");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmPasswordController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Re-type Seller Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(
                  height: screenHeight * .055,
                ),
                FormButton(
                    text: "Register New Food Stall",
                    onPressed: () async {
                      if (_formKey.currentState!.validate())  {
                        await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                        postDetailsToFirestore();
                      }
                    }
                ),
              ],
            ),
          )
      ),
    );
  }
}




//List all created stall
class CurrentStall extends StatefulWidget {
  const CurrentStall({Key? key}) : super(key: key);

  @override
  State<CurrentStall> createState() => _CurrentStallState();

}

class _CurrentStallState extends State<CurrentStall> {

  CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StreamBuilder(
        stream: ref.orderBy("stallName").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context, index) {
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                    return Card(
                      child: SizedBox(
                          child: ListTile(
                            title: Text(documentSnapshot['ownerName']),
                            subtitle: Text(documentSnapshot['stallName']),
                            leading: const Image(
                                image: AssetImage('assets/images/logo.png')
                            ),
                            trailing:  IconButton(icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => stallEdit(uid: documentSnapshot['uid'],)));
                                }
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



// Edit selected stall
class stallEdit extends StatefulWidget {
  String uid;
  stallEdit({Key? key,  required this.uid }) : super(key: key);

  @override
  State<stallEdit> createState() => _stallEditState();
}

class _stallEditState extends State<stallEdit> {

  @override
  Widget build(BuildContext context) {
    String uid = widget.uid;
    DocumentReference ref = FirebaseFirestore.instance.collection('StallUsers').doc(uid);
    return Scaffold(
      appBar: AppBar(title: const Text("Food Stall Editor"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body:
      StreamBuilder<dynamic>(
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
                          const SizedBox(height: 20),
                          const Text("OWNER NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['ownerName'], textAlign: TextAlign.center),
                          IconButton(onPressed: ()
                          => stallOwnerNameEditor(context, uid)
                              , icon: const Icon(Icons.edit)),

                          const SizedBox(height: 20),
                          const Text("PHONE NUMBER :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['ownerPhone'], textAlign: TextAlign.center),
                          IconButton(onPressed: ()
                          => stallPhoneEditor(context, uid)
                              , icon: const Icon(Icons.edit)),

                          const SizedBox(height: 20),
                          const Text("OWNER EMAIL :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['email'], textAlign: TextAlign.center),
                          IconButton(onPressed: ()
                          => stallEmailEditor(context, uid)
                              , icon: const Icon(Icons.edit)),

                          const SizedBox(height: 20),
                          const Text("STALL NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['stallName'], textAlign: TextAlign.center),
                          IconButton(onPressed: ()
                          => stallNameEditor(context, uid)
                              , icon: const Icon(Icons.edit)),

                          const SizedBox(height: 20),
                          ElevatedButton(onPressed:() => deleteStall(context, uid), child: const Text('Delete'))
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


Future<void> deleteStall(BuildContext context, String uid) async {

  FirebaseFirestore.instance.collection('StallUsers').doc(uid).delete();

  Fluttertoast.showToast(msg:"Successfully deleted the account");
}

Future adminUpdateOwnerName(String ownerName, String uid) async{

  final CollectionReference stall = FirebaseFirestore.instance.collection('StallUsers');

  return await stall.doc(uid).update({'ownerName':ownerName} );
}

Future adminUpdatePhone(String ownerPhone, String uid) async{

  final CollectionReference stall = FirebaseFirestore.instance.collection('StallUsers');

  return await stall.doc(uid).update({'ownerPhone':ownerPhone} );
}

Future adminUpdateEmail(String email, String uid) async{

  final CollectionReference stall = FirebaseFirestore.instance.collection('StallUsers');

  return await stall.doc(uid).update({'email':email} );
}

Future adminUpdateStallName(String stallName, String uid) async{

  final CollectionReference stall = FirebaseFirestore.instance.collection('StallUsers');

  return await stall.doc(uid).update({'stallName':stallName} );
}



// FoodStall form editor
void stallOwnerNameEditor(BuildContext e, String uid){

  final TextEditingController _stallOwnerNameController = TextEditingController();

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
              controller: _stallOwnerNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Full Name",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: () {
              adminUpdateOwnerName(_stallOwnerNameController.text, uid);
              Fluttertoast.showToast(msg:"Successful");
              // Navigator.pop(context);
            }, child: const Text('Submit'))
          ],
        ),
      ));
}

void stallPhoneEditor(BuildContext e , String uid){

  final TextEditingController _stallPhoneController = TextEditingController();

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
              controller: _stallPhoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Phone Number",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: () {
              adminUpdatePhone(_stallPhoneController.text, uid);
              Fluttertoast.showToast(msg:"Successful");
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => const PagesNavigate()));
            }, child: const Text('Submit'))
          ],
        ),
      ));
}

void stallEmailEditor(BuildContext e, String uid){

  final TextEditingController _stallEmailController = TextEditingController();

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
              controller: _stallEmailController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: () {
              adminUpdateEmail(_stallEmailController.text, uid);
              Fluttertoast.showToast(msg:"Successful");
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => const PagesNavigate()));
            }, child: const Text('Submit'))
          ],
        ),
      ));
}

void stallNameEditor(BuildContext e, String uid){

  final TextEditingController _stallNameController = TextEditingController();

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
              controller: _stallNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Stall Name",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: () {
              adminUpdateStallName(_stallNameController.text, uid);
              Fluttertoast.showToast(msg:"Successful");
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => const PagesNavigate()));
            }, child: const Text('Submit'))
          ],
        ),
      ));
}




class FormButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  const FormButton({this.text = "", this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  const InputField(
      {this.labelText,
        this.onChanged,
        this.onSubmitted,
        this.errorText,
        this.keyboardType,
        this.textInputAction,
        this.autoFocus = false,
        this.obscureText = false,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

