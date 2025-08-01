import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz.dart';
import 'package:ignou_bscg/model/user_scores.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';

class Plays extends StatelessWidget {
  String id;String name;
  Plays({super.key,required this.name,required this.id});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Send.bg,
        automaticallyImplyLeading: true,
        title: Text("$name Quizes",style: TextStyle(color: Colors.white),),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(id).collection("Scores").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No users found.'));
              }
              final users = snapshot.data!.docs.map((doc) {
                return UserScore.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();
              return ListView.builder(
                itemCount: users.length,
                padding: const EdgeInsets.all(3.0),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final quiz = users[index];
                  return PlayCards(quiz: quiz,);
                },
              );
          }
        },
      ),
    );
  }

}

class PlayCards extends StatelessWidget {
  UserScore quiz;
   PlayCards({super.key,required this.quiz});
  String formatDateTime(String dateTimeString) {
    try {
      // Parse the input string to DateTime
      DateTime dateTime = DateTime.parse(dateTimeString);

      // Format the DateTime
      String formattedDate = DateFormat('hh a on dd/MM/yy').format(dateTime);
      return formattedDate;
    } catch (e) {
      // Handle any parsing errors
      return 'Long Time Ago';
    }
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return InkWell(
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Container(
          width: w-20,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(quiz.pic),
                ),
                subtitle: Text("Quiz Id : ${quiz.id}",style: TextStyle(fontSize: 8),),
                title: Text(formatDateTime(quiz.completedAt)),
                trailing: Text(quiz.score.toStringAsFixed(1),style: TextStyle(fontWeight: FontWeight.w800,color: Colors.green,fontSize: 23),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 15,),
                  Text("Full Marks :"),
                  Text(quiz.fullMarks.toString(),style: TextStyle(color: Colors.purpleAccent),),
                  SizedBox(width: 5,),
                  Text("Negative : "),
                  Text(quiz.negativeMarks.toStringAsFixed(1),style: TextStyle(color: Colors.red),),
                  SizedBox(width: 5,),
                  Text("Questions : "),
                  Text(quiz.questions.length.toString(),style: TextStyle(color: Colors.orange),),
                ],
              ),
              SizedBox(width: 13,),
            ],
          ),
        ),
      ),
    );
  }
}
