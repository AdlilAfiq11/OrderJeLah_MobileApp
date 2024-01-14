import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/Models/noticeModel.dart';

import '../../../Models/noticeModel (2023_05_13 03_49_08 UTC).dart';

class createNotice extends StatefulWidget {
  String uid;
  createNotice({Key? key, required this.uid}) : super(key: key);

  @override
  State<createNotice> createState() => _createNoticeState();
}

class _createNoticeState extends State<createNotice> {
  final TextEditingController _Textcontroller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Notice"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text("Create A Notice For The Food Stall"),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintText: "Enter The Date",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _Textcontroller,
                minLines: 2,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintText: "Your Text Here",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final docNotice = FirebaseFirestore.instance
                    .collection("StallUsers")
                    .doc(widget.uid)
                    .collection("StallNotice")
                    .doc();

                NoticeModel noticeModel = NoticeModel();

                noticeModel.stallID = widget.uid;
                noticeModel.noticeID = docNotice.id;
                noticeModel.noticeDate = _dateController.text;
                noticeModel.noticeText = _Textcontroller.text;
                final json = noticeModel.toJson();
                await docNotice.set(json);

                Fluttertoast.showToast(msg: "Successfully");
                Navigator.pop(context);
              },
              child: const Text("Send Notice"),
            ),
          ],
        )));
  }
}
