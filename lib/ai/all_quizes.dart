import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';

import '../model/quiz.dart';
import '../model/quiz_type.dart';

class AllQuizes extends StatefulWidget {
   AllQuizes({super.key,required this.questions,required this.quiz});
  List<QuizQuestion> questions ;
   QuizTypeModel quiz;

  @override
  State<AllQuizes> createState() => _AllQuizesState();
}

class _AllQuizesState extends State<AllQuizes> {
   bool doing = false;

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: AppBar(
        title: Text("All Generated Quizes"),
      ),
      persistentFooterButtons:[ doing?SizedBox():InkWell(
          onTap: () async {
            try {
              setState(() {
                doing = true;
              });
              for (var qu in widget.questions) {
                await FirebaseFirestore.instance.collection("Quiz").doc(
                    widget.quiz.id).collection("Quizes").doc(qu.id).set(
                    qu.toMap());
              }
              Navigator.pop(context);
              Navigator.pop(context);
              setState(() {
                doing = false;
              });
            }catch(e){
              Send.message(context, "$e", false);
              setState(() {
                doing = false;
              });
            }
          },
          child: Send.see(w, "Yes Add it to the Quiz", Icon(Icons.rocket_launch_sharp,color: Colors.white,))),],
        body: doing?Center(child: CircularProgressIndicator()):SingleChildScrollView(
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.questions.length,
            itemBuilder: (context,index){
              QuizQuestion question= widget.questions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Text(
                            "Q${index + 1}: ${question.question}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          mycards(question),

                        ],
                      ),
                    ),
                  ),
                );
            },
          ),
        ),
      )
    );
  }

  Widget mycards(QuizQuestion question){
    return  ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: question.options.length,
      itemBuilder: (context, optionIndex) {
        final isCorrect = optionIndex == question.correctOption;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green[200] : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCorrect ? Colors.green : Colors.grey,
              ),
            ),
            child: ListTile(
              title: Text(question.options[optionIndex]),
            ),
          ),
        );
      },
    );
  }
}


