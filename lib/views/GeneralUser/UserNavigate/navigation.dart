
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fyp2/GeneralUser/Pages/HomePage.dart';
import 'package:fyp2/GeneralUser/Pages/ProfilePage.dart';


class PagesNavigate extends StatefulWidget {

  const PagesNavigate({Key? key,}) : super(key: key);

  @override
  _PagesNavigate createState() => _PagesNavigate();
}

class _PagesNavigate extends State<PagesNavigate> {

  final List _options=[
    HomePage(),const ProfilePage()
  ];
  int _currentIndex=0;


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
      child: Scaffold(
        body: Container(
          child: Center(
              child: (_options[_currentIndex])),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.teal,
          height: 55.0,
          buttonBackgroundColor: Colors.teal,
          backgroundColor: Colors.white,
          animationCurve: Curves.bounceOut,
          items: const <Widget>[
            Icon(FlutterIcons.home_outline_mco,color: Colors.white, size: 25),
            Icon(FlutterIcons.account_outline_mco,color: Colors.white, size: 25),
          ],
          onTap: (index){
            setState(() {
              _currentIndex=index;
            });
          },
        ),
      ),
    );
  }
}