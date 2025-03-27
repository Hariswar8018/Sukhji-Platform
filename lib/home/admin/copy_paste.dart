import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/quiz/add/add_quiz_id.dart';
import 'package:ignou_bscg/quiz/home/small_card.dart';

class CopyPaste extends StatefulWidget {
  String uno;
  CopyPaste({super.key,required this.uno});

  @override
  State<CopyPaste> createState() => _CopyPasteState();
}

class _CopyPasteState extends State<CopyPaste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Send.bg,
        automaticallyImplyLeading: true,
        title: Text("${widget.uno}",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Text("No ${widget.uno} found "),
      ),
    );
  }
}