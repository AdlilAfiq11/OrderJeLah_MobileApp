
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/Admin/AdminNavigate/drawerItem.dart';
import 'package:fyp2/Admin/Pages/ListStall.dart';
import 'package:fyp2/Admin/Pages/analysis.dart';
import 'package:fyp2/Admin/Pages/geofence.dart';
import 'package:fyp2/Auth/AdminLoginScreen.dart';
import 'package:fyp2/Models/adminModel.dart';
import 'package:fyp2/main.dart';


class adminNavigate extends StatefulWidget {
  const adminNavigate({Key? key}) : super(key: key);

  @override
  State<adminNavigate> createState() => _adminNavigateState();

}

class _adminNavigateState extends State<adminNavigate> {

  AdminModel loggedInUser = AdminModel();

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection("admin")
        .doc('admin')
        .get()
        .then((value) {
      loggedInUser = AdminModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final value = await showDialog <bool>(
            context: context,
            builder: (context){
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text ('Do you want to exit?'),
                actions: [
                  ElevatedButton(onPressed: ()=> Navigator.of(context).pop(false), child: const Text('No')),
                  ElevatedButton(onPressed: ()=> Navigator.of(context).pop(true), child: const Text('Yes'))
                ],
              );

            });
        if (value!=null){
          return Future.value(value);
        }else{
          return Future.value(false);
        }
      },
      child: Drawer(
        child: Material(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
            child: Column(
              children: [
                headerWidget(),
                const SizedBox(height: 40,),
                const Divider(thickness: 1, height: 10, color: Colors.grey,),
                const SizedBox(height: 40,),
                DrawerItem(
                  name: 'Food Stall',
                  icon: Icons.food_bank_outlined,
                  onPressed: ()=> onItemPressed(context, index: 0),
                ),
                const SizedBox(height: 30,),
                DrawerItem(
                    name: 'Stall Analysis',
                    icon: Icons.description_outlined,
                    onPressed: ()=> onItemPressed(context, index: 1)
                ),
                const SizedBox(height: 30,),
                DrawerItem(
                    name: 'Monitored Area',
                    icon: Icons.location_on,
                    onPressed: ()=> onItemPressed(context, index: 2)
                ),
                const SizedBox(height: 30,),
                const Divider(thickness: 1, height: 10, color: Colors.grey,),
                const SizedBox(height: 30,),
                DrawerItem(
                    name: 'Log out',
                    icon: Icons.logout,
                    onPressed: ()=> onItemPressed(context, index: 3)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}){
    Navigator.pop(context);

    switch(index){
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ListStall()));
        break;
    }
    switch(index){
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const stallAnalysis()));
        break;
    }
    switch(index){
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const geofenceEditor()));
        break;
    }
    switch(index){
      case 3:
        Navigator.of(context).pushAndRemoveUntil(
          // the new route
          MaterialPageRoute(
            builder: (BuildContext context) => const WelcomeScreen(),
          ),

          // this function should return true when we're done removing routes
          // but because we want to remove all other screens, we make it
          // always return false
              (Route route) => false,
        );
        break;
    }
  }


  Widget headerWidget() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/appIcon.png'),
        ),
        const SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${loggedInUser.name}", style: const TextStyle(fontSize: 14, color: Colors.white)),
            const SizedBox(height: 10,),
            Text("${loggedInUser.email}", style: const TextStyle(fontSize: 14, color: Colors.white))
          ],
        )
      ],
    );

  }
}
