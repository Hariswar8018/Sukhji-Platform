import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/second/second.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/model/transaction.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:ignou_bscg/quiz/add/add_quiz_id.dart';
import 'package:ignou_bscg/quiz/add/update_quiz.dart';
import 'package:ignou_bscg/quiz/home/instruction_conduction.dart';
import 'package:ignou_bscg/quiz/home/open_quiz.dart';
import 'package:provider/provider.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:slide_countdown/slide_countdown.dart';

class ChatUser extends StatelessWidget {
  QuizTypeModel quiz;bool isadmin;int review;
  ChatUser({super.key,required this.quiz,required this.isadmin, this.review=0});

  String day(){
    try {
      DateTime quizDateTime = DateTime.parse(quiz.id);
      if(quizDateTime.hour<12){
        return quizDateTime.hour.toString() + ":00 AM";
      }
      if(quizDateTime.hour==12){
        return quizDateTime.hour.toString() + ":00 PM";
      }
      return (quizDateTime.hour - 12 ).toString() + ":00 PM";
    }catch(e){
      return "10:00 AM";
    }
  }
  String dayend(){
    try {
      DateTime quizDateTime = DateTime.parse(quiz.id);
      if(quizDateTime.hour<12){
        return quizDateTime.hour.toString() + ":30 AM";
      }
      if(quizDateTime.hour==12){
        return quizDateTime.hour.toString() + ":30 PM";
      }
      return (quizDateTime.hour - 12 ).toString() + ":30 PM";
    }catch(e){
      return "10:30 AM";
    }
  }
  h(BuildContext context) async {
    try {
      final _userprovider = Provider.of<UserProvider>(context, listen: false);
      _userprovider.refreshuser();
    }catch(e){

    }
  }
  sendd() async {
    try {
      String str = DateTime.now().toString();
      TransactionModel tran = TransactionModel(answer: true,
          name: quiz.qName,
          method: "",
          rupees: quiz.price.toDouble(),
          pay: true,
          status: "Debited",
          coins: quiz.price.toInt(),
          time: str,
          time2: quiz.id,
          nameUid: "Transaction Debited",
          id: str,
          pic: "",
          transactionId: ""
      );
      await FirebaseFirestore.instance.collection("users").doc(
          FirebaseAuth.instance.currentUser!.uid).collection("Transaction")
          .doc(str).set(tran.toJson());
    }catch(e){

    }

  }

  String checks() {
    try {
      final quizDateTime = DateTime.parse(quiz.id);
      final now = DateTime.now();
      final difference = now.difference(quizDateTime).inMinutes;

      if (difference < 0) {
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

  Future<void> yesgoing(BuildContext modalContext, BuildContext parentContext, UserModel _user) async {
    try {
      // Deduct amount from user's balance
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_user.uid)
          .update({
        "amount": FieldValue.increment(-quiz.price),
      });

      // Update registered users in Quiz collection
      await FirebaseFirestore.instance.collection("Quiz").doc(quiz.id).update({
        "registered": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });

      // Refresh user data
      UserProvider _userProvider = Provider.of(parentContext, listen: false);
      await _userProvider.refreshuser();

      // Close the modal sheet
      Navigator.pop(modalContext);

      // Show success message
      Send.message(parentContext, "Success! You entered the contest.", true);
      sendd();
    } catch (e) {
      // Handle errors and still close the modal sheet
      Navigator.pop(modalContext);
      Send.message(parentContext, "An error occurred while entering the contest.", false);
    }
  }

  void f(BuildContext context, UserModel _user) {
    double w = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      isDismissible: false, // Prevent dismissal
      enableDrag: false, // Disable drag-to-close
      builder: (BuildContext modalContext) {
        // Start the async operation after showing the modal
        WidgetsBinding.instance.addPostFrameCallback((_) {
          yesgoing(modalContext, context, _user);
        });

        return Container(
          width: w,
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Paying & Registering',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 20),
              Center(child: CircularProgressIndicator()),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Text(
                  'Do not Press Back or Close App',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w=MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Center(
        child: InkWell(
          onLongPress: (){
            if(isadmin){
              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateQuizId(quiz: quiz,)));
            }
          },
          onTap: (){
            if(isadmin){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OpenQuiz(quiz: quiz,admin: isadmin,review: review,)));
            }else if(checks()=="Yes"){
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: w,
                    color: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Awaiting Result',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                        Image.asset("assets/result.png",width: w/3-40,),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: Text('Result will be shared on ${dayend()}',textAlign: TextAlign.center,),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
              return ;
            }else if((quiz.registered.contains(FirebaseAuth.instance.currentUser!.uid)||("Quiz Overed"==r456757()))){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OpenQuiz(quiz: quiz,admin: isadmin,review: review,)));
            }else{
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: w,
                    color: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${quiz.price}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                        QuizCountdown(quizId: quiz.id),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: Text('Pay ₹${quiz.price} to Enter this Quiz and fight with Participants',textAlign: TextAlign.center,),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                            onTap: () async {
                              try {
                                if (_user == null || quiz == null) {
                                  Send.message(context, "Unexpected error occurred. Please try again.", false);
                                  return;
                                }
                                if (_user!.amount >= quiz.price) {
                                  // Deduct money and update Firestore
                                  Navigator.pop(context);
                                  f(context, _user);
                                } else {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Wallet()));
                                  Send.message(context, "You don't have enough money in your wallet.", false);
                                }
                              } catch (e) {
                                Navigator.pop(context);
                                Send.message(context, "Error: $e", false);
                              }
                            },

                            child: Send.see(w, "Pay & Continue", Icon(Icons.payments,color: Colors.white,)))
                      ],
                    ),
                  );
                },
              );
            }
          },
          child: Container(
            width: w-20,
            decoration:BoxDecoration(
              color: Colors.white,
              border:Border.all(
                color:Colors.red.shade200
              ),
            ),
            child: Column(
              children:[
                SizedBox(height: 10,),
                Text("${day()} Quiz",style: TextStyle(fontWeight: FontWeight.w700,fontSize: w/38),),
                Text("${quiz.qName} : Questions = ${quiz.questions.length}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/28),),
                Text("Negative Marking : 1/3",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/40),),
                SizedBox(height: 8,),
                Container(
                  width: w/2,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6,bottom: 6,left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.diamond,color: Colors.white,size: 20,),
                          SizedBox(width: 7,),
                          Text("Winning Prize : ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/35,color: Colors.white),),
                          Text("₹ ${quiz.winning}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: w/35,color: Colors.white),),
                        ],
                      ),
                    )),
                SizedBox(height: 10,),
                Container(
                  width: w-20,
                  child: Row(
                    children: [
                      Container(
                        width: w-80,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${quiz.registered.length.toString()} Registered",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/40,color: Colors.red),),
                                  Spacer(),
                                  Text("${y()} Spot Left",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/40,color: Colors.indigo),),
                                ],
                              ),
                            ),
                            SizedBox(height: 3,),
                            Container(
                              width: w-80,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0,right: 15),
                                child: ProgressBar(
                                  value: (quiz.registered.length/quiz.spots),
                                  height: 5,
                                  color: Colors.red,backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(3)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10,top: 4,bottom: 4),
                          child: Text("₹ ${quiz.price}",style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Text("Quiz Declare Time : ${declare()}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: w/40,color: Colors.redAccent),),
                Container(
                  width: w-20,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15),
                    child: Row(
                      children: [
                        Text("${day()}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/40),),
                        Spacer(),
                        !se()?check():QuizCountdown(quizId: quiz.id),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                InstructionConduction(quiz: quiz,on: true,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8),
                        child: Container(
                          width: w/3,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("About Quiz",style: TextStyle(fontSize: w/40,fontWeight: FontWeight.w800),)),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 8,),
              ]
            )
          ),
        ),
      ),
    );
  }

  String r456757(){
    try {
      if(se()){
        return "None";
      }
      final quizDateTime = DateTime.parse(quiz.id);
      final now = DateTime.now();
      final difference = now.difference(quizDateTime).inMinutes;
      print("gfvbbbbv");
      print(difference);
      if(difference >= 0 && difference <= 10){
        return "LIVE?";
      }
      return "Quiz Overed";
    } catch (e) {
      return "Quiz Overed";
    }
  }

  Widget check() {
    try {
      final quizDateTime = DateTime.parse(quiz.id);
      final now = DateTime.now();
      final difference = now.difference(quizDateTime).inMinutes;
      print("gfvbbbbv");
      print(difference);
      if(difference >= 0 && difference <= 2){
        return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 2
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0,bottom: 6,right: 8,top: 6),
              child: Text("LIVE",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
            ));
      }
      return Text("Quiz Overed",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800),);
    } catch (e) {
      return Text("Quiz Overed",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800),);
    }
  }


  bool se() {
    try {
      final quizDateTime = DateTime.parse(quiz.id);
      final now = DateTime.now();
      final difference = now.difference(quizDateTime).inMinutes;
      if (quizDateTime.isAfter(now)) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  String y(){
    print((quiz.registered.length/quiz.spots));
    int ui=quiz.spots - quiz.registered.length;
    if(ui.isNegative){
      return "0";
    }
    return "$ui";
  }
  String declare(){
    try {
      DateTime quizDateTime = DateTime.parse(quiz.id);
      if(quizDateTime.hour<12){
        return quizDateTime.hour.toString() + ":30 AM";
      }
      if(quizDateTime.hour==12){
        return quizDateTime.hour.toString() + ":30 PM";
      }
      return (quizDateTime.hour - 12 ).toString() + ":30 PM";
    }catch(e){
      return "10:30 AM";
    }
  }
  String send() {
    try {
      DateTime quizDateTime = DateTime.parse(quiz.id);
      DateTime now = DateTime.now();

      // Calculate the difference as a Duration
      Duration timeDifference = quizDateTime.difference(now);

      // Check if the quiz date is today
      bool isToday = quizDateTime.year == now.year &&
          quizDateTime.month == now.month &&
          quizDateTime.day == now.day;

      if (!timeDifference.isNegative) {
        return isToday
            ? "Quiz Today at ${quizDateTime.hour}:00"
            : "Quiz on ${quizDateTime.hour}:00";
      } else {
        return isToday
            ? "Quiz ended Today at ${quizDateTime.hour}:00"
            : "Quiz ended on ${quizDateTime.hour}:00";
      }
    } catch (e) {
      return "Quiz ended on 10:00";
    }
  }

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
      padding: EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
      style: TextStyle(fontSize: 10, color:Send.bg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      separatorStyle: TextStyle(color: Colors.white),
    );
  }
}