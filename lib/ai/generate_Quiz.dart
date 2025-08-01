import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz_type.dart';

import '../model/quiz.dart';
import 'dart:convert';

import 'all_quizes.dart';

class GenerateQuiz extends StatefulWidget {
  QuizTypeModel quiz;
   GenerateQuiz({required this.quiz, super.key});

  @override
  State<GenerateQuiz> createState() => _GenerateQuizState();
}

class _GenerateQuizState extends State<GenerateQuiz> {

  TextEditingController name=TextEditingController();
  TextEditingController num=TextEditingController();
  TextEditingController times=TextEditingController();
  void initState(){
    name.text=widget.quiz.qName;
    num.text="10";
    times.text="30";
  }

  bool isgenerating=false;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Quiz ",style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900),),
      ),
      backgroundColor: isgenerating?Colors.black:Colors.white,
      body: isgenerating?Column(
        children: [
          LinearProgressIndicator(),
          Spacer(),
          Center(
            child: Image.network(width: w,"https://static1.makeuseofimages.com/wordpress/wp-content/uploads/2025/02/google-gemini-memory-anim.gif"),
          ),
          Text("एक बार फिर सर?",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w700,color: Colors.white),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text("आप कुछ ज्यादा ही अलसी हो. जब तक हो रहा है फिल्म देखते रहिए ! ",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w300)),
          ),
          Spacer(),
        ],
      ):Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info),
            Text("Confirm Quiz Topic to be fetched",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 19),),
            Send.editor(name, w, "Confirm Quiz Topic", false),
            SizedBox(height: 20,),
            Icon(Icons.numbers),
            Text("Total no. of Quizes ( atmost 20  )",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 19),),
            Send.editor(num, w, "10",true),
            SizedBox(height: 20,),
            Icon(Icons.alarm),
            Text("Total time for each Quiz ( 10 to 60 seconds )",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 19),),
            Send.editor(times, w, "30",true),
            SizedBox(height: 40,),
            InkWell(
              onLongPress: (){
                print(response);
                jsoncreation(response);
              },
                onTap: (){
                  try {
                    int i = int.parse(num.text);
                    timeQuiz=int.parse(times.text);
                    if (i < 0 || i > 30) {
                      Send.message(context, "Quiz asking too long", false);
                      return;
                    }
                    Send.message(context, "Starting Generation", true);
                    setState(() {
                      isgenerating=true;
                    });
                    String str='''
                    Return an JSON format {
                        "question": "What is the capital of France?",
                         "options": ["Paris", "London", "Berlin", "Rome"],
                           "correctOption": 0
                           }
                     quiz questions for ${name.text} Test which should be VERY HARD . Answer and Question should be in Hindi Language. Return ${i+1} Quizes with answers in JSON  ''';
                    getGeminiResponse(str);
                  }catch(e){
                    Send.message(context, "Put Integer / Number in given Quiz Type", false);
                  }
                },
                child: Send.se(w, "Generate Quiz Now"))
          ],
        ),
      ),
    );
  }
  int timeQuiz = 30;

  void jsoncreation(String response) {


    // Step 1: Clean the response
    String cleaned = response
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .split('\n')
        .where((line) => !line.trim().startsWith('I/flutter'))
        .join('\n')
        .trim();

    try {
      // Step 2: Decode JSON
      List<dynamic> decodedData = jsonDecode(cleaned);

      // Step 3: Convert to List<QuizQuestion>
      List<QuizQuestion> questions = decodedData
          .map((e) => QuizQuestion.fromJsons(e, timeQuiz))
          .toList();

      // Step 4: Use result
      for (var q in questions) {
        print(q);
      }
      nowgo(questions);
    } catch (e) {
      print('Failed to parse JSON: $e');
    }
  }

  void nowgo(List<QuizQuestion> questions){
    isgenerating=false;
    setState(() {

    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => AllQuizes(questions: questions, quiz: widget.quiz,)));

  }



  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit Story Creation"),
        content: Text("Are you sure you want to exit Story Section? The last response if not saved will be deleted"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay on screen
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit app
            child: Text("Exit"),
          ),
        ],
      ),
    ) ??
        false; // Default to false if dismissed
  }

  Future<void> getGeminiResponse(String prompt) async {
    const apiKey = "AIzaSyApOxsiwJdG89a-aZUMPsmu4vTnhSnhr5U"; // Replace with your API key
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    try {
      final responseContent =
      await model.generateContent([Content.text(prompt)]);
      String geminiResponseText = responseContent.text ?? "No response";

      setState(() {
        response = geminiResponseText; // Store Gemini's response

      });
      jsoncreation(response);
    } catch (e) {
      print("Error fetching response from Gemini: $e");
    }
  }
  String response="";


}
