import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/quiz/fetcj.dart';
import 'package:ignou_bscg/quiz/home/open_quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstructionConduction extends StatefulWidget {
  QuizTypeModel quiz;int review;bool on;
 InstructionConduction({super.key,required this.quiz,this.review=0,this.on=false});

  @override
  State<InstructionConduction> createState() => _InstructionConductionState();
}

class _InstructionConductionState extends State<InstructionConduction> {
  late int remainingTime;
  late Timer countdownTimer;

  @override
  void initState() {
  super.initState();
  remainingTime = 30; // Start from 30 seconds

  if(widget.on){
    return ;
  }
  // Timer to update the remaining time every second
  countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
    if(widget.on){
      return ;
    }
  setState(() async {
  if (remainingTime > 0) {
  remainingTime--;
  } else {
  timer.cancel();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> items = prefs.getStringList('items')??['Yes'];
  if(items.contains(widget.quiz.id)){
    Navigator.pop(context);
    Navigator.pop(context);
    Send.message(context, "You already given Test",false);
  }else{
    items=items+[widget.quiz.id];
    await prefs.setStringList('items', items);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            QuizScreen(quizId: widget.quiz.id,
              clid: widget.quiz.id, islive: false, correctmark: widget.quiz.marks,)));
  }
  }
  });
  });
  }

  @override
  void dispose() {
  countdownTimer.cancel(); // Cancel the timer when the widget is disposed
  super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Send.bg,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: Text(widget.review==0?"About Quiz / Description":"Important Instructions",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            widget.on?SizedBox():Text(
              "    Page will Timeout in : $remainingTime seconds",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            Text(
              "   ${widget.quiz.qName}",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0,right: 13),
              child: RichText(
                text: TextSpan(
                  text: "Total Questions : ", // Static part
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Ensure the color matches the theme
                  ),
                  children: [
                    TextSpan(
                      text: widget.quiz.questions.length.toString(), // Dynamic part
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Highlight the remaining time
                      ),
                    ),
                    TextSpan(
                      text: "         Correct Marks : ", // Static part
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Ensure the color matches the theme
                      ),),
                    TextSpan(
                      text: widget.quiz.marks.toString(), // Dynamic part
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Highlight the remaining time
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0,right: 13),
              child: RichText(
                text: TextSpan(
                  text: "Negative Mark : ", // Static part
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Ensure the color matches the theme
                  ),
                  children: [
                    TextSpan(
                      text: (widget.quiz.marks*1/3).toStringAsFixed(1), // Dynamic part
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red, // Highlight the remaining time
                      ),
                    ),
                    TextSpan(
                      text: "         Skip Marks : ", // Static part
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Ensure the color matches the theme
                      ),),
                    TextSpan(
                      text: "0", // Dynamic part
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange, // Highlight the remaining time
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 7,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                    width: w-20,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Send.bg,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        // specify the radius for the top-left corner
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        // specify the radius for the top-right corner
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          f(w, 0),
                          f(w, 1),
                        ],
                      ),
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.review==0?widget.quiz.description:widget.quiz.instruction),
            )
          ],
        ),
      ),
      persistentFooterButtons: [
        widget.on?SizedBox():InkWell(
            onTap: () async {
              countdownTimer.cancel(); // Cancel the timer when the widget is disposed
               SharedPreferences prefs = await SharedPreferences.getInstance();
              List<String> items = prefs.getStringList('items')??['Yes'];
              if(items.contains(widget.quiz.id)){
                Navigator.pop(context);
                Navigator.pop(context);
                Send.message(context, "You already given Test",false);
              }else{
                items=items+[widget.quiz.id];
                await prefs.setStringList('items', items);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        QuizScreen(quizId: widget.quiz.id,
                          clid: widget.quiz.id, islive: false, correctmark: widget.quiz.marks,)));
              }
            },
            child: Send.se(w, "Continue to Test")),
      ],
    );
  }
  Widget f(double w, int yes)=>InkWell(
    onTap: (){
      setState(() {
        widget.review=yes;
      });
      print(widget.review);
    },
    child: Container(
      width: w/2-20,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: yes==widget.review?Colors.white:Send.bg,
      ),
      child: Center(
        child: Text(yiop(yes),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: yes==widget.review?Colors.black:Colors.white)),
      ),
    ),
  );
  String yiop(int y){
    if(y==0){
      return "Description";
    }else if(y==1){
      return "Instruction";
    }else {
      return "Invites";
    }
  }
}
