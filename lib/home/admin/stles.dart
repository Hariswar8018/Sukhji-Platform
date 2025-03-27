import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/model/user_scores.dart' as df;
import 'package:ignou_bscg/quiz/admin/stles.dart';
import 'package:ignou_bscg/quiz/fetcj.dart';
import 'package:ignou_bscg/quiz/home/scores.dart';
import 'package:ignou_bscg/quiz/home/small_card.dart';

import '../../quiz/add/add_quiz.dart';

class Admin_Quiz extends StatefulWidget {
  Admin_Quiz({super.key,required this.quiz,this.admin=true});
  QuizTypeModel quiz;bool admin;
  @override
  State<Admin_Quiz> createState() => _Admin_QuizState();
}

class _Admin_QuizState extends State<Admin_Quiz> {
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.notifications,color: Colors.black,)),
          SizedBox(height: 10,),
        ],
      ),
      floatingActionButton: widget.admin?FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuizScreen(id: widget.quiz.id,)));
      },
        backgroundColor: Send.bg,child: Icon(Icons.add,color: Colors.white,),):SizedBox(),
      body:widget.admin?after(w,h):(!se()?after(w, h):before(h, w)),
    );
  }

  bool se() {
    try {
      final quizDateTime = DateTime.parse(widget.quiz.id);
      final now = DateTime.now();
      final difference = now.difference(quizDateTime).inMinutes;

      if (quizDateTime.isAfter(now)) {
        return true;
      }

      return difference >= 0 && difference <= 10;
    } catch (e) {
      return false;
    }
  }

  Widget after(double w,double h){
    return Stack(
      children: [
        Container(
          width: w,
          height: h,
          child: Column(
            children: [
              Container(
                width: w,
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/banner.jpg"))
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Container(
          width: w,
          height: h,
          child: Column(
            children: [
              Spacer(),
              Container(
                width: w,
                height: h-200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 9,),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0,top: 18,right: 28),
                        child: Text("GENERAL KNOWLEDGE",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22,color: Send.bg),),
                      ),
                      Padding(
                        padding:const EdgeInsets.only(left: 28.0,top: 2,right: 28),
                        child: Text("Questions attached to this QuizSet"),
                      ),
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
                      review==0?Container(
                        width: w,
                        height: h-400,
                        child: StreamBuilder(
                          stream: Fire.collection('Quiz').doc(widget.quiz.id).collection("Quizes").snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return Center(child: CircularProgressIndicator());
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                list = data
                                    ?.map((e) => QuizQuestion.fromJson(e.data())).toList() ?? [];
                                return ListView.builder(
                                  itemCount: list.length,
                                  padding: EdgeInsets.only(top: 10),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ChatUserr(
                                      quiz: list[index], admin: widget.admin, quizid: widget.quiz.id,
                                    );
                                  },
                                );
                            }
                          },
                        ),
                      ):Container(
                        width: w,
                        height: h-400,
                        child: StreamBuilder(
                          stream: Fire.collection('Quiz').doc(widget.quiz.id).collection("UserScores").snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return Center(child: CircularProgressIndicator());
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                _listt = data?.map((e) => df.UserScore.fromJson(e.data())).toList() ?? [];
                                return ListView.builder(
                                  itemCount: _listt.length,
                                  padding: EdgeInsets.only(top: 10),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ScoresCard(
                                      quiz: _listt[index],isadmin:widget.admin,quid: widget.quiz.id,
                                      indexx: index,
                                    );
                                  },
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int review=0;

  Widget f(double w, int yes)=>InkWell(
    onTap: (){
      setState(() {
        review=yes;
      });
      print(review);
    },
    child: Container(
      width: w/2-20,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: yes==review?Colors.white:Send.bg,
      ),
      child: Center(
        child: Text(yiop(yes),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: yes==review?Colors.black:Colors.white)),
      ),
    ),
  );

  String yiop(int y){
    if(y==0){
      return "Questions";
    }else if(y==1){
      return "Leaderboards";
    }else {
      return "Invites";
    }
  }

  Widget before(double h,double w){
    return Stack(
      children: [
        Container(
          width: w,
          height: h,
          child: Column(
            children: [
              Container(
                width: w,
                height: h-280,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/banner.jpg"))
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Container(
          width: w,
          height: h,
          child: Column(
            children: [
              Spacer(),
              Container(
                width: w,
                height: 320,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0,top: 18,right: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 9,),
                      Text("Today's Quiz on"),
                      Text("GENERAL KNOWLEDGE",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22,color: Send.bg),),
                      SizedBox(height: 8,),
                      Text("This Quiz will start in"),
                      SizedBox(height: 15,),
                      QuizCountdown(quizId: widget.quiz.id),
                      SizedBox(height: 18,),
                      Row(
                        children: [
                          Icon(Icons.diamond,color: Colors.blueAccent,),
                          Text(" ₹500 First Prize Winner",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.w600),),
                        ],
                      ),SizedBox(height: 6,),
                      Center(child: InkWell(
                          onTap: (){
                            try {
                              DateTime th = DateTime.parse(widget.quiz.id);
                              bool isWithin10Minutes = th.difference(DateTime.now()).abs().inMinutes <= 10;
                              if (isWithin10Minutes) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        QuizScreen(quizId: widget.quiz.id,
                                          clid: widget.quiz.id, islive: false, correctmark: widget.quiz.marks,)));
                              }else{
                                Send.message(context, "Quiz will be Acvtivate on ${th.hour}:00 on the Day of Quiz", false);
                              }
                            }catch(e){
                              Send.message(context, "Looks like we Encounter an Error", false);
                            }
                          },
                          child: Send.se(w-20, "Play Quiz Now")))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<QuizQuestion> list = [];

  List<df.UserScore> _listt = [];

  late Map<String, dynamic> userMap;

  late Map<String, dynamic> userMap2;

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
}
