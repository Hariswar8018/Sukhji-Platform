import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ignou_bscg/model/quiz.dart';

class ChatUserr extends StatelessWidget {
  QuizQuestion quiz;bool admin;String quizid;
   ChatUserr({super.key,required this.quiz,required this.admin,required this.quizid});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return ListTile(
      onLongPress: () async {
        await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete ?"),
            content: Text("Delete Questions"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed:() async {
                 await FirebaseFirestore.instance.collection('Quiz').doc(quizid).collection("Quizes").doc(quiz.id).delete();
                 Navigator.pop(context);
                     },
                child: Text("Yes"),
              ),
            ],
          );
        },
        );
      },
      tileColor: Colors.white,
      leading: SvgPicture.asset(
        "assets/test-svgrepo-com (1).svg",
        height: w/6-30,
      ),
      title: Text("${quiz.question}",style: TextStyle(fontWeight: FontWeight.w700),),
      subtitle: Text(quiz.options[quiz.correctOption],style: TextStyle(fontWeight: FontWeight.w700),),
      trailing: Text(quiz.Timequiz.toString()+" sec",style: TextStyle(color: Colors.orange,fontSize: 15),),
    );
  }
}
