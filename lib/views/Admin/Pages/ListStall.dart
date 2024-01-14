
import 'package:flutter/material.dart';
import 'package:fyp2/Admin/AdminNavigate/adminNavigate.dart';
import 'package:fyp2/Admin/stallEditor/stallRegister.dart';


class ListStall extends StatelessWidget {
  const ListStall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const adminNavigate(),
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.blue,
        title: const Text('List of Food Stall'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const registerStall()));
      },
        icon :const Icon(Icons.add),
        label: const Text('Add New Food Stall'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
         child: CurrentStall(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}