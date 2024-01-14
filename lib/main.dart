import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/Admin/AdminNavigate/adminNavigate.dart';
import 'package:fyp2/Auth/AdminLoginScreen.dart';
import 'package:fyp2/Auth/LoginRegister.dart';
import 'package:fyp2/Auth/OwnerLoginScreen.dart';
import 'package:fyp2/Service/localPushNotification.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();

  await Firebase.initializeApp(
    name: "OrderJeLah",
    options: const FirebaseOptions(apiKey: "AIzaSyCeUpPLPFC3fAhCjdyx1SouTyBL1trlRxI",
      appId: "com.example.fyp2",
      messagingSenderId: "XXX",
      projectId: "orderjelah-db732")
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OrderJeLah!',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const WelcomeScreen(),
      );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
              child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logoFYP.png"),
                      scale: 2.0,
                    ),
              ),
          ),
          ),
          FittedBox(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const AlertBox()));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding:
                const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      "START ORDERING",
                      style: Theme.of(context).textTheme.button?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class AlertBox extends StatelessWidget {
  const AlertBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4)
        ),
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white70,
                child: const Icon(Icons.account_circle, size: 60),
              ),
            ),
            Expanded(
                child: Container(
                  color: Colors.teal,
                  child: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            color: Colors.white,
                            child: const Text('Seller'),
                            onPressed: ()=> {
                              Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const OwnerLoginScreen()))
                            },
                          ),
                          RaisedButton(
                            color: Colors.white,
                            child: const Text('Customer'),
                            onPressed: ()=> {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => const LoginScreen()))
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}




//ForAdmin
class mainScreen extends StatelessWidget {
  const mainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      drawer: const adminNavigate(),
      appBar: AppBar(
        title: const Text('OrderJeLah!: Administrator'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logoFYP.png"),
                  scale: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}