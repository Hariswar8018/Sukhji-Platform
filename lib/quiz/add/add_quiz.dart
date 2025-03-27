import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz.dart';

class AddQuizScreen extends StatefulWidget {
  String id;
  AddQuizScreen({required this.id});

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final TextEditingController quizIdController = TextEditingController();

  final List<QuizQuestion> questions = [];

  void saveQuizToFirestore(BuildContext context) async {
    final quizId = quizIdController.text.trim();

    if (quizId.isEmpty || questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a quiz ID and add questions.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .set({
        'questions': questions.map((q) => q.toMap()).toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz saved successfully!')),
      );

      quizIdController.clear();
      questions.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  final TextEditingController questionController = TextEditingController();

  final TextEditingController option1Controller = TextEditingController();

  final TextEditingController option2Controller = TextEditingController();

  final TextEditingController option3Controller = TextEditingController();

  final TextEditingController option4Controller = TextEditingController();

  final TextEditingController correctOptionController = TextEditingController();

  int time=8;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Send.bg,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          title: Text('Add Quiz',style: TextStyle(color: Colors.white),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              r(questionController, w, "Type Question"),
              SizedBox(height: 15),
              Row(
                children: [
                  butt(1),
                  SizedBox(width: 5,),
                  a(option1Controller, w, "Option 1"),
                ],
              ),
              Row(
                children: [
                  butt(2),
                  SizedBox(width: 5,),
                  a(option2Controller, w, "Option 2"),
                ],
              ),
              Row(
                children: [
                  butt(3),
                  SizedBox(width: 5,),
                  a(option3Controller, w, "Option 3"),
                ],
              ),
              Row(
                children: [
                  butt(4),
                  SizedBox(width: 5,),
                  a(option4Controller, w, "Option 4"),
                ],
              ),
              SizedBox(height: 10),
              Text("   Quiz Time",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  r12(w, 5),r12(w,7), r12(w, 10),r12(w,15),r12(w, 20),r12(w, 30),r12(w,60)
                ],
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final question = questionController.text;
                  final options = [
                    option1Controller.text,
                    option2Controller.text,
                    option3Controller.text,
                    option4Controller.text,
                  ];
                  final correctOption =i ;
                  if (question.isEmpty ||
                      options.any((o) => o.isEmpty) ||
                      correctOption < 1 ||
                      correctOption > 4) {
                    print(question);print(options);print(correctOption);
                    Send.message(context, "Fill all fields correctly", false);
                    return;
                  }
                  String id=DateTime.now().microsecondsSinceEpoch.toString();
                  QuizQuestion qu= QuizQuestion(
                    question: question,
                    options: options,
                    correctOption: correctOption - 1, id: id, Timequiz: hj,
                  ) ;
                  await FirebaseFirestore.instance.collection("Quiz").doc(widget.id).collection("Quizes").doc(id).set(qu.toMap());
                  j();
                  questionController.clear();
                  option1Controller.clear();
                  option2Controller.clear();
                  option3Controller.clear();
                  option4Controller.clear();
                  correctOptionController.clear();
                  Send.message(context, "Question added successfully !", true);
                },
                child: Send.se(w, "Save Quiz"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  int hj=7;
  Widget r12(double w,int yi)=>InkWell(
    onTap: (){
      setState(() {
        hj=yi;
      });
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: yi==hj?Colors.blue.shade50:Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
              color: yi==hj?Colors.black:Colors.black,
              width: yi==hj?3: 1
          ),
        ),
        child: Center(child: Padding(
          padding: const EdgeInsets.only(left: 13.0,right: 13,top: 7,bottom: 7),
          child: Text(yi.toString(),style: TextStyle(fontWeight: FontWeight.w600),),
        )),
      ),
    ),
  );
  j() async {
    try{
      await FirebaseFirestore.instance.collection("Quiz").doc(widget.id).update({
        "questions":FieldValue.arrayUnion([DateTime.now().toString()])
      });
    }catch(e){

    }
  }
  int i=1;

  Widget butt(int y)=>InkWell(
    onTap: (){
      setState(() {
        i=y;
      });
    },
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: y==i?Colors.green:Colors.red,
      ),
      child: y==i?Icon(Icons.verified_rounded,color: Colors.white,):Icon(Icons.close,color: Colors.white,),
    ),
  );

  Widget r(TextEditingController _controller,double w,String str){
    return  Center(
      child: Container(
        width: w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
          child: TextField(
            minLines: 3,maxLines: 20,
            controller: _controller,
            keyboardType: TextInputType.name,
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

  Widget a(TextEditingController _controller,double w,String str){
    return  Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          width: w-107,
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
              keyboardType: TextInputType.name,
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
      ),
    );
  }
}
