

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/Models/StallUsers.dart';
import 'package:fyp2/Models/stallMenu.dart';


class registerMenu extends StatefulWidget {
  const registerMenu({Key? key, this.onSubmitted}) : super(key: key);

  final Function(String? menuID, String? menuName, String? menuPrice, String? stallID, String? menuStatus, String? menuType, String? menuCounter)? onSubmitted;


  @override
  State<registerMenu> createState() => _registerMenuState();

}

class _registerMenuState extends State<registerMenu> {

  late String  menuName, menuID, menuPrice, stallName, stallID, menuStatus, menuType, menuCounter;

  User? user = FirebaseAuth.instance.currentUser;

  StallUsers loggedInUser = StallUsers();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('StallUsers')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = StallUsers.fromMap(value.data());
      setState(() {});
    });

    menuID ="";
    menuName = "";
    menuPrice = "";
    stallName = "";
    stallID = "";
    menuType = "Standard";
    menuCounter = "0";
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Menu"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .01),
            Text(
              "Create Your New Menu Today",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  menuName = value;
                });
              },
              labelText: "Menu Name",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  menuPrice = value;
                });
              },
              labelText: "Menu Price",
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            SizedBox(
              height: screenHeight * .025,
            ),
            FormButton(
              text: "Create",
              onPressed: (){
                final menu = StallMenu(
                  menuID: menuID,
                  menuName: menuName,
                  menuPrice: menuPrice,
                  stallID: stallID,
                  stallName: loggedInUser.stallName,
                  menuStatus: "Active",
                  menuType: "Standard",
                  menuCounter: "0",
                );
                createMenu(menu);
                Navigator.pop(context);
              },
            ),
          ],
        ),

      ),
    );
  }
}



class registerHighlighted extends StatefulWidget {
  const registerHighlighted({Key? key, this.onSubmitted}) : super(key: key);

  final Function(String? menuID, String? name, String? menuName, String? menuPrice, String? stallID, String? highlightID, String? menuStatus, String? menuType, String? menuCounter)? onSubmitted;


  @override
  State<registerHighlighted> createState() => _registerHighlightedState();

}

class _registerHighlightedState extends State<registerHighlighted> {

  late String  menuName, menuID, menuPrice, stallID, stallName, highlightID, menuStatus, menuType, menuCounter;

  User? user = FirebaseAuth.instance.currentUser;

  StallUsers loggedInUser = StallUsers();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('StallUsers')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = StallUsers.fromMap(value.data());
      setState(() {});
    });


    menuID ="";
    menuName = "";
    menuPrice = "";
    stallName = "";
    stallID = "";
    highlightID = "";
    menuType = "Highlighted";
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Highlighted Menu"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .01),
            Text(
              "Create Your Highlighted Menu Today",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  menuName = value;
                });
              },
              labelText: "Menu Name",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  menuPrice = value;
                });
              },
              labelText: "Menu Price",
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(
              height: screenHeight * .025,
            ),
            FormButton(
              text: "Create",
              onPressed: (){
                final menu = StallMenu(
                  menuID: menuID,
                  menuName: menuName,
                  menuPrice: menuPrice,
                  stallID: stallID,
                  stallName: loggedInUser.stallName,
                  menuStatus: "Active",
                  menuType: "Highlighted",
                  menuCounter: "0",
                );
                final menuHighlight = HighlightedMenu(
                  menuID: menuID,
                  menuName: menuName,
                  menuPrice: menuPrice,
                  stallID: stallID,
                  stallName: loggedInUser.stallName,
                  highlightID: highlightID,
                  menuStatus: "Active",
                  menuType: "Highlighted",
                  menuCounter: "0",
                );
                createMenu(menu);
                createHighlightedMenu(menuHighlight, menu);
                Navigator.pop(context);
              },
            ),
          ],
        ),

      ),
    );
  }
}




//Show Current Menu
class CurrentMenu extends StatefulWidget {
  const CurrentMenu({Key? key}) : super(key: key);

  @override
  State<CurrentMenu> createState() => _CurrentMenuState();

}

class _CurrentMenuState extends State<CurrentMenu> {


  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final CollectionReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/StallMenu');
    return Scaffold(
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  if (documentSnapshot['stallID'] == user?.uid) {
                    if(documentSnapshot['menuType']=="Standard"){
                      return Card(
                        child: SizedBox(
                            child: ListTile(
                              title: Text(documentSnapshot['menuName']),
                              subtitle: Text(documentSnapshot['menuStatus']),
                              leading: const Image(
                                  image: AssetImage('assets/images/restaurant.png')
                              ),
                              trailing: IconButton(icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context) => menuEdit(menuID: documentSnapshot['menuID'],)));
                                  }
                              ),
                            )
                        ),
                      );
                    }
                    else {
                      return Card(
                        child: SizedBox(
                            child: ListTile(
                              title: Text(documentSnapshot['menuName']),
                              subtitle: Text(documentSnapshot['menuStatus']),
                              leading: const Image(
                                  image: AssetImage('assets/images/restaurant.png')
                              ),
                              trailing: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const IconButton(icon: Icon(Icons.star),
                                        onPressed: null,
                                        color: Colors.amber,
                                    ),
                                    IconButton(icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) => menuEdit(menuID: documentSnapshot['menuID'],)));
                                        }
                                    ),
                                  ],
                              )
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


//Edit selected menu
class menuEdit extends StatefulWidget {
  
  String menuID;
  menuEdit({Key? key, required this.menuID}) : super(key: key);

  @override
  State<menuEdit> createState() => _menuEditState();
}

class _menuEditState extends State<menuEdit> {

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String menuID = widget.menuID;
    DocumentReference ref = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/StallMenu').doc(menuID);

    return Scaffold(
      appBar: AppBar(title: const Text("Menu Editor"),
        centerTitle: true,
      ),
      body: StreamBuilder<dynamic>(
        stream: ref.snapshots(),
        builder: (BuildContext context, snapshot){
          if(snapshot.hasData && snapshot.data.exists){
            Map<String, dynamic> documentSnapshot = snapshot.data!.data();
            final menuStatus = documentSnapshot['menuStatus'];
            return ListView(
              children: [
                Card(
                    child: SizedBox(
                      child: ListBody(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          const Text("MENU NAME :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['menuName'], textAlign: TextAlign.center),
                          IconButton(onPressed: ()
                          => menuNameEditor(context, menuID)
                              , icon: const Icon(Icons.edit)),

                          const SizedBox(height: 20),
                          const Text("MENU PRICE :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['menuPrice'], textAlign: TextAlign.center),
                          IconButton(onPressed: ()
                            => menuPriceEditor(context, menuID)
                          , icon: const Icon(Icons.edit)),

                          const SizedBox(height: 20),
                          const Text("MENU STATUS :" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text("\n"+documentSnapshot['menuStatus'], textAlign: TextAlign.center),

                          const SizedBox(height: 20),
                          ElevatedButton(onPressed:() => deleteProduct(menuID), child: const Text('Delete')),
                          ElevatedButton(onPressed:() => userUpdateMenuStatus(menuID,menuStatus), child: const Text('Change Menu Status')),
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
  //delete
  Future<void> deleteProduct(String menuID) async {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference del1 = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/StallMenu');
    CollectionReference del2 = FirebaseFirestore.instance.collection('HighlightedMenu');
    await del1.doc(menuID).delete();
    await del2.doc(menuID).delete();
    Fluttertoast.showToast(msg:"Successful");
  }

}






Future createMenu(StallMenu menu) async {
  User? user = FirebaseAuth.instance.currentUser;
  final docMenu = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/StallMenu').doc();

  menu.stallID = user.uid;
  menu.menuID = docMenu.id;

  final json = menu.toJson();
  await docMenu.set(json);

}

Future createHighlightedMenu(HighlightedMenu menuHighlight, StallMenu menu) async {
  User? user = FirebaseAuth.instance.currentUser;
  final docMenu = FirebaseFirestore.instance.collection('HighlightedMenu').doc(menu.menuID);

  menuHighlight.stallID = user!.uid;
  menuHighlight.menuID = menu.menuID;
  menuHighlight.highlightID = menu.menuID;

  final json = menuHighlight.toJson();
  await docMenu.set(json);
}


//update function
Future userUpdateMenuName(String menuName, String menuID) async{

  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference menu = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/StallMenu');

  return await menu.doc(menuID).update({'menuName':menuName} );
}

Future userUpdatePrice(String menuPrice, String menuID) async{

  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference menu = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/StallMenu');

  return await menu.doc(menuID).update({'menuPrice':menuPrice} );
}

Future userUpdateMenuStatus(String menuID, String menuStatus) async{

  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference menu = FirebaseFirestore.instance.collection('StallUsers/' + user!.uid + '/StallMenu');

  if(menuStatus == "Active"){
    menuStatus = "Inactive";
  }
  else{
    menuStatus = "Active";
  }

  return await menu.doc(menuID).update({'menuStatus':menuStatus});
}



//update menu name form
void menuNameEditor(BuildContext e,String menuID){

  final TextEditingController _menuNameController = TextEditingController();
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
              controller: _menuNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Menu Name",
              ),
            ),
             const SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: () {
              userUpdateMenuName(_menuNameController.text, menuID);
              Fluttertoast.showToast(msg:"Successful");
              // Navigator.pop(context);
            }, child: const Text('Submit'))
          ],
        ),
      ));
}
//update menu price form
void menuPriceEditor(BuildContext e, String menuID){

  final TextEditingController _menuPriceController = TextEditingController();

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
              controller: _menuPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Menu Price",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: () {
              userUpdatePrice(_menuPriceController.text, menuID);
              Fluttertoast.showToast(msg:"Successful");
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
