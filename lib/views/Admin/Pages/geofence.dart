
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/Admin/AdminNavigate/adminNavigate.dart';
import 'package:fyp2/Admin/locationEditor/geolocationEditor.dart';
import 'package:fyp2/Models/geofence.dart';

class geofenceEditor extends StatefulWidget {
  const geofenceEditor({Key? key}) : super(key: key);

  @override
  State<geofenceEditor> createState() => _geofenceEditorState();
}

class _geofenceEditorState extends State<geofenceEditor> {


  @override
  GeofenceModel geofenceModel = GeofenceModel();

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection('admin')
        .doc('Geofence')
        .get()
        .then((value) {
      geofenceModel = GeofenceModel.fromMap(value.data());
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const adminNavigate(),
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.blue,
        title: const Text('Location Editor'),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
            children:<Widget> [
              ListView(
                children: [
                  Card(
                    child:ListTile(
                        title: const Text("POINTED LATITUDE"),
                        subtitle: Text ("${geofenceModel.latitude}"),
                        trailing: IconButton(icon: const Icon(Icons.edit_sharp),
                          onPressed:() {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const geolocationEditor()));
                          }
                          ,)
                    ),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text("POINTED LONGITUDE"),
                        subtitle: Text ("${geofenceModel.longitude}"),
                        trailing: IconButton(icon: const Icon(Icons.edit_sharp),
                          onPressed:() {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const geolocationEditor()));
                          }
                          ,)
                    ),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text("GEOFENCE RADIUS"),
                        subtitle: Text ("${geofenceModel.radius}" " Meter"),
                        trailing: IconButton(icon: const Icon(Icons.edit_sharp),
                          onPressed:()  => bottomRadiusEditor(context),
                        )
                    ),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text("LIMIT OF THE DEVICE"),
                        subtitle: Text ("${geofenceModel.limitDevice}" " Device"),
                        trailing: IconButton(icon: const Icon(Icons.edit_sharp),
                          onPressed:()  => bottomLimitDeviceEditor(context)
                          ,)
                    ),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text("TOTAL CURRENT DEVICE"),
                        subtitle: Text ("${geofenceModel.totalDevice}" " Device"),
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
  void bottomRadiusEditor(BuildContext e){

    final TextEditingController RadiusController = TextEditingController();

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
                controller: RadiusController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Geofence Radius",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () {
                radiusUpdate(RadiusController.text);
                Fluttertoast.showToast(msg:"Successfully");
                Navigator.pop(context);
              }, child: const Text('Submit'))
            ],
          ),
        ));
  }
  void bottomLimitDeviceEditor(BuildContext e){

    final TextEditingController LimitDeviceController = TextEditingController();

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
                controller: LimitDeviceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Limit Of The Device",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () {
                limitDeviceUpdate(LimitDeviceController.text);
                Navigator.pop(context);
                Fluttertoast.showToast(msg:"Successfully");
              }, child: const Text('Submit'))
            ],
          ),
        ));
  }
}


Future radiusUpdate(String radius) async{

  final CollectionReference geo = FirebaseFirestore.instance.collection('admin');

  return await geo.doc('Geofence').update({'radius': radius});

}
Future limitDeviceUpdate(String limitDevice) async{

  final CollectionReference geo = FirebaseFirestore.instance.collection('admin');

  return await geo.doc('Geofence').update({'limitDevice': limitDevice});

}