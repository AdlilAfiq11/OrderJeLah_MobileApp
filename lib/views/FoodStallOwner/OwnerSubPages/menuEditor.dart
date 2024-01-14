import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fyp2/FoodStallOwner/menuCreator/menuRegister.dart';

class MenuEditor extends StatefulWidget {
  const MenuEditor({Key? key}) : super(key: key);

  @override
  State<MenuEditor> createState() => _MenuEditorState();
}

class _MenuEditorState extends State<MenuEditor> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.teal,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        spacing: 12,
        spaceBetweenChildren: 12,
        children:[
          SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
            onTap:  (){
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => const registerMenu()));
            },
          ),
          SpeedDialChild(
            child: const Icon (Icons.star),
            backgroundColor: Colors.amber,
            onTap:  (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const registerHighlighted()));
            },
          ),
        ],
      ),
      body:  const Center(
        child:  CurrentMenu()
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
