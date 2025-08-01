import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';

class Pay_Winners extends StatefulWidget {
  String game_id,userid,username;
  Pay_Winners({super.key,required this.userid,required this.game_id,required this.username,required this.ludo});
  bool ludo;
  @override
  State<Pay_Winners> createState() => _Pay_WinState();
}

class _Pay_WinState extends State<Pay_Winners> {
  TextEditingController score = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Send.bg,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Edit Prize for ${widget.username}",style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("   Amount Winned",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            r14(prize,w,"Amount",true),
            Text("   Points Winned",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            r14(score,w,"Points",true),
            SizedBox(height: 30,),
            pay?SizedBox():InkWell(
                onTap: (){
                  try {
                    double s = double.parse(prize.text) ?? 0.0;
                    double s1 = double.parse(score.text) ?? 0.0;
                    if (s == 0.0||s1==0.0) {
                      Send.message(context, "Type more than 0", false);
                    }
                    setState(() {
                      pay = true;
                    });
                  }catch(e){
                    Send.message(context, "Please Write Prize : $e", false);
                  }
                },
                child: Center(child: Send.se(w, "Pay & Update"))),
            pay?Text("Sure? Paying User is Irreversible Process"):SizedBox(),
            pay?InkWell(
                onTap: () async {
                  try {
                    try {
                      double rd = double.parse(prize.text) ?? 0.0;
                      double rds = double.parse(score.text) ?? 0.0;
                      await FirebaseFirestore.instance.collection(widget.ludo?"LUDO":"CARROM")
                          .doc(widget.game_id).collection("Players")
                          .doc(widget.userid).update({
                        "prizewins": rd,
                        "prizepoints": rds,
                      });
                      Send.message(context, "LeaderBoard", true);
                    } catch (e) {
                      Send.message(context, "$e", false);
                    }
                    try {
                      double rd = double.parse(prize.text) ?? 0.0;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userid)
                          .update({
                        "amount": rd,
                      });
                      Send.message(context, "Money Added", true);
                    } catch (e) {
                      Send.message(context, "$e", false);
                    }
                    Send.message(context, "Updated ! Redirecting back in 3 Seconds", true);
                    Timer(Duration(seconds: 3), (){
                      Navigator.pop(context);
                    });
                  }catch(e){
                    Send.message(context, "$e", false);
                  }
                },
                child: Center(child: Send.se(w, "I CONFIRM"))):SizedBox(),
          ],
        ),
      ),
    );
  }

  bool pay=false;

  TextEditingController prize=TextEditingController();

  Widget r14(TextEditingController _controller,double w,String str,bool yrrt){
    return  Center(
      child: Container(
        width: w-10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
          child: TextField(
            controller: _controller,
            keyboardType:yrrt?TextInputType.number: TextInputType.name,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w800
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
              hintText: str,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
