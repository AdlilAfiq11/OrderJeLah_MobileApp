
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/GeneralUser/subProfilePage/myOrder.dart';
import 'package:fyp2/GeneralUser/subProfilePage/myProfile.dart';
import 'package:fyp2/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  dynamic data;

  int totalDevice=0;

  Widget textfield({@required hintText}) {
    return Material(
      elevation: 2,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.teal,
        title: const Text('OrderJeLah!'),
        centerTitle: true,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            IconButton(icon: Icon(Icons.restaurant),
              onPressed: null,
            ),
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "PROFILE PAGE",
                  style: TextStyle(
                    fontSize: 30,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/appIcon.png'),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 12),
              Container(

                height: 330,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SimpleElevatedButton(
                      onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const myProfile()));
                      },
                      child: const Text('My Profile'),
                    ),
                    SimpleElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => myOrder()));
                      },
                      child: const Text('My Order'),
                    ),
                    SimpleElevatedButton(
                      onPressed: () async {
                        totalDevice=0;
                        final DocumentReference ref = FirebaseFirestore.instance.collection("admin").doc('Geofence');
                        await ref.get().then<dynamic>((DocumentSnapshot snapshot) async{
                          setState(() {
                            data = snapshot.data();
                              totalDevice = (data['totalDevice']);
                                  if (totalDevice>0){
                                    totalDevice--;
                                  }
                                  else {
                                    totalDevice = 0;
                                  }
                          });
                        });
                        await ref.update({'totalDevice' : totalDevice});

                        // EasyGeofencing.stopGeofenceService();
                        updateAccount();
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
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Future updateAccount() async{

  User? user = FirebaseAuth.instance.currentUser;

  final DocumentReference status = FirebaseFirestore.instance.collection('users').doc(user!.uid);

  return await status.update({'account': "Inactive"});
}




class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.teal;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SimpleElevatedButton extends StatelessWidget {
  const SimpleElevatedButton(
      {this.child,
        this.color,
        this.onPressed,
        this.borderRadius = 6,
        this.padding = const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        Key? key})
      : super(key: key);
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return ElevatedButton(
      child: child,
      style: ElevatedButton.styleFrom(
        padding: padding,
        primary: color ?? currentTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}
