import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/admin/edit_prize.dart';
import 'package:ignou_bscg/model/quiz.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/model/user_scores.dart' as df;
import 'package:ignou_bscg/quiz/add/add_quiz.dart';
import 'package:ignou_bscg/quiz/admin/stles.dart';
import 'package:ignou_bscg/quiz/fetcj.dart';
import 'package:ignou_bscg/quiz/home/instruction_conduction.dart';
import 'package:ignou_bscg/quiz/home/scores.dart';
import 'package:slide_countdown/slide_countdown.dart';

class OpenQuiz extends StatefulWidget {
  QuizTypeModel quiz;bool admin;
  int review;
 OpenQuiz({super.key,required this.quiz,required this.admin,this.review=0});
  @override
  State<OpenQuiz> createState() => _OpenQuizState();
}
class QuizCountdown extends StatelessWidget {
  final String quizId; // Assume this is a datetime string like "2025-03-07 14:00:00"

  QuizCountdown({required this.quizId});

  @override
  Widget build(BuildContext context) {
    // Parse the quizId as a DateTime
    DateTime quizDateTime = DateTime.parse(quizId);

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the difference as a Duration
    Duration timeDifference = quizDateTime.difference(now);

    // Handle cases where the quiz has already started or ended
    if (timeDifference.isNegative) {
      return Center(
        child: Text(
          "Quiz has already started!",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return SlideCountdownSeparated(
      duration: timeDifference,
      padding: EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 7),
      style: TextStyle(fontSize: 24, color: Colors.white),
      decoration: BoxDecoration(
        color: Send.bg,
        borderRadius: BorderRadius.circular(5),
      ),
      separatorStyle: TextStyle(color: Colors.white),
    );
  }
}
class _OpenQuizState extends State<OpenQuiz> {

  void initState(){

  }
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
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    InstructionConduction(quiz: widget.quiz,on: true,)));
          }, icon: Icon(Icons.info,color: Colors.black,)),
          SizedBox(width: 10,),
        ],
      ),
      floatingActionButton: widget.admin?FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuizScreen(id: widget.quiz.id,)));
      },backgroundColor: Send.bg,child: Icon(Icons.add,color: Colors.white,),):SizedBox(),
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
                        child: Text(widget.quiz.qName,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22,color: Send.bg),),
                      ),
                      Padding(
                        padding:const EdgeInsets.only(left: 28.0,top: 2,right: 28),
                        child: Text("${widget.quiz.questions.length} Questions    +${widget.quiz.marks} Correct   -${((widget.quiz.marks)*1/3).toStringAsFixed(1)} Incorrect"),
                      ),
                      Padding(
                        padding:const EdgeInsets.only(left: 28.0,top: 2,right: 28),
                        child: Text(widget.review==0?"Questions attached to this QuizSet":"Winners of this QuizSet"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 18.0,bottom: 8),
                        child: Center(
                          child: Container(
                              width: w-23,
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
                      widget.review==0?Container(
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
                      ):
                      Container(
                        width: w,
                        height: h - 400,
                        child: StreamBuilder(
                          stream: Fire.collection('Quiz')
                              .doc(widget.quiz.id)
                              .collection("UserScores")
                              .orderBy("score", descending: true) // Ensures highest score is first
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return Center(child: CircularProgressIndicator());
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                _listt = data
                                    ?.map((e) => df.UserScore.fromJson(e.data()))
                                    .toList() ??
                                    [];
                                return ListView.builder(
                                  itemCount: _listt.length,
                                  padding: EdgeInsets.only(top: 10),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Container(
                                        width: w-20,
                                        height: 100,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.yellow,
                                              offset: Offset(0, 2),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("# 1",style: TextStyle(fontWeight: FontWeight.w800),),
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(_listt[0].pic),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Name",style: TextStyle(fontWeight: FontWeight.w800),),
                                                Text(formatTo17Words(_listt[0].name,12),style: TextStyle(fontWeight: FontWeight.w400),),
                                              ],
                                            ),
                                            SizedBox(width: 15,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("District",style: TextStyle(fontWeight: FontWeight.w800),),
                                                Text(formatTo17Words(_listt[0].address,10),style: TextStyle(fontWeight: FontWeight.w400),),
                                              ],
                                            ),
                                            SizedBox(width: 15,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Score",style: TextStyle(fontWeight: FontWeight.w800),),
                                                Text(formatTo17Words(_listt[0].score.toStringAsFixed(1),4),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.red),),
                                              ],
                                            ),
                                           Spacer(),
                                            InkWell(
                                              onTap: (){
                                                if(widget.admin){
                                                  Navigator.push(context, MaterialPageRoute(
                                                      builder: (context) =>Pay_Win(quiz_id: widget.quiz.id, userid: _listt[0].id,
                                                        username: _listt[0].name,)));
                                                }
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  widget.admin?Icon(Icons.edit,color: Colors.green,):Text("Win",style: TextStyle(fontWeight: FontWeight.w800),),
                                                  Text("₹"+_listt[0].prizewin,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return ScoresCard(
                                        quiz: _listt[index],isadmin: widget.admin,quid: widget.quiz.id,
                                        indexx: index,
                                      );
                                    }
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
  String formatTo17Words(String input,int i) {
    // If the input is shorter than 17 characters, pad it with spaces
    if (input.length < i) {
      return input.padRight(i, ' ');
    }

    // If the input is longer than 17 characters
    // Split the input into words
    List<String> words = input.split(' ');
    String result = '';

    // Build the result word by word until it reaches 17 characters
    for (String word in words) {
      if ((result + word).length <= i) {
        result += (result.isEmpty ? '' : ' ') + word;
      } else {
        break;
      }
    }

    // Pad the result with spaces to ensure it's exactly 17 characters
    return result.padRight(i, ' ');
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
                      Text(widget.quiz.qName,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22,color: Send.bg),),
                      SizedBox(height: 8,),
                      Text("This Quiz will start in"),
                      SizedBox(height: 15,),
                      QuizCountdown(quizId: widget.quiz.id),
                      SizedBox(height: 18,),
                      Row(
                        children: [
                          Icon(Icons.diamond,color: Colors.blueAccent,),
                          Text(" ₹${widget.quiz.winning} First Prize Winner",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Center(child: InkWell(
                          onTap: (){
                            if(checks()=="Not Yet Live"){
                              Send.message(context, "Quiz will be Acvtivate on ${r4557890(widget.quiz.orderNumber)} on the Day of Quiz", false);
                            }else if(checks()=="Live"){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => InstructionConduction(quiz: widget.quiz,)));
                            }else if(checks()=="Yes"){
                              Navigator.pop(context);
                              Send.message(context, "Quiz Time is Overed ! We are Now Awaiting Result", false);
                            }else{

                              Send.message(context, "Quiz Time is Overed !", false);

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
  String r4557890(String yu89){
    try {
      int yu8 = int.parse(yu89);
      if (yu8 < 12) {
        return "$yu8 AM";
      }
      if (yu8 == 12) {
        return "$yu8 PM";
      }
      return "${yu8-12} PM";
    }catch(e){
      return "$yu89:00";
    }
  }
  String checks() {
    try {
      final quizDateTime = DateTime.parse(widget.quiz.id);
      final now = DateTime.now();
      final difference = now.difference(quizDateTime).inMinutes;
      final difference2 = now.difference(quizDateTime).inSeconds;
      print(difference);
      print(difference2);
      if (difference < 0) {
        return "Not Yet Live"; // Current time is before the quiz start time
      }
      if (difference2 < 0) {
        return "Not Yet Live"; // Current time is before the quiz start time
      }
      if (difference >= 0 && difference <= 2) {
        return "Live"; // Quiz is live within the first 10 minutes
      }

      if (difference >= 2 && difference <= 30) {
        return "Yes"; // Quiz is in the 15-30 minute range
      }

      return "Quiz Overed"; // Any other time range
    } catch (e) {
      return "Quiz Overed"; // Handle invalid quiz.id or other errors
    }
  }

  List<QuizQuestion> list = [];
  List<df.UserScore> _listt = [];
  late Map<String, dynamic> userMap;
  late Map<String, dynamic> userMap2;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
}
