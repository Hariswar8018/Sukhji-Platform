import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ignou_bscg/global/send.dart';
import 'dart:async';

import 'package:ignou_bscg/model/quiz.dart';
import 'package:ignou_bscg/model/user_scores.dart' as df;
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:ignou_bscg/quiz/completed.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  final String clid;
bool islive;
int correctmark;
   QuizScreen({required this.quizId, required this.clid,required this.islive,required this.correctmark});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  late Future<List<QuizQuestion>> _questionsFuture;
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  Timer? _timer;
  int _timeRemaining = 30; // 30 seconds for each question
  Map<int, int> _selectedOptions = {};
  double _score = 0;
  bool _isAppMinimized = false;

  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _questionsFuture = fetchQuizQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<List<QuizQuestion>> fetchQuizQuestions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.quizId)
        .collection('Quizes')
        .get();

    if (querySnapshot.docs.isEmpty) return [];

    return querySnapshot.docs
        .map((doc) => QuizQuestion.fromJson(doc.data()))
        .toList();
  }

  void _startTimer(int timeQuiz) {
    _timer?.cancel();
    _timeRemaining = timeQuiz; // Set timer based on current question's Timequiz
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _moveToNextQuestion(skipped: true);
        }
      });
    });
  }


  void _moveToNextQuestion({bool skipped = false}) {
    _saveAnswer(skipped);
    if (_currentQuestionIndex + 1 < _questions.length) {
      setState(() {
        _currentQuestionIndex++;
        final currentQuestion = _questions[_currentQuestionIndex];
        _startTimer(currentQuestion.Timequiz); // Pass Timequiz for the next question
      });
    } else {
      _timer?.cancel();
      _submitScore();
      _showCompletionDialog();
    }
  }

  Future<void> _submitScore() async {
    String id=DateTime.now().toIso8601String();
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    final userScoreData = df.UserScore(
      questions: _questions,
      score: _score,
      completedAt: id,
      isLive: false,
      fullMarks: _questions.length * widget.correctmark,
      negativeMarks: widget.correctmark * 1 / 3,
      noCorrect: _questions.where((q) => _selectedOptions[_questions.indexOf(q)] == q.correctOption).length,
      noWrong: _questions.where((q) => _selectedOptions[_questions.indexOf(q)] != q.correctOption && _selectedOptions[_questions.indexOf(q)] != null).length,
      noSkip: _questions.where((q) => _selectedOptions[_questions.indexOf(q)] == null).length,
      name: _user!.Name, pic: _user.pic, address: _user.address, prizewin: '0', id: _userId,
    );


    await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.quizId)
        .collection('UserScores')
        .doc(_userId)
        .set(userScoreData.toMap());

    // Save score in the user's collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('Scores')
        .doc(widget.quizId)
        .set(userScoreData.toMap());
    gh();
  }
  gh() async {
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId).update({
        "win":FieldValue.increment(1),
      });
    }catch(e){

    }
  }
  void _saveAnswer(bool skipped) async {
    final currentQuestion = _questions[_currentQuestionIndex];
    final selectedOption = _selectedOptions[_currentQuestionIndex];
    double scoreChange = 0;
    int noCorrect = 0, noWrong = 0, noSkip = 0;

    if (skipped || selectedOption == null) {
      noSkip++;
      scoreChange = 0; // No score for skipped questions
    } else if (selectedOption == currentQuestion.correctOption) {
      noCorrect++;
      scoreChange = widget.correctmark.toDouble(); // Correct answer
    } else {
      noWrong++;
      scoreChange = -(widget.correctmark) * 1 / 3; // Wrong answer
    }

    setState(() {
      _score += scoreChange;
    });

    // Update Firestore with the user's answer and score
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('QuizAnswers')
        .doc(widget.quizId)
        .set({
      'answers.${currentQuestion.id}': selectedOption ?? -1,
      'score': _score,
      'nocorrect': FieldValue.increment(noCorrect),
      'nowrong': FieldValue.increment(noWrong),
      'noskip': FieldValue.increment(noSkip),
    }, SetOptions(merge: true));
  }

  void _showCompletionDialog() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>
            Completed()));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _isAppMinimized = true;
      _kickUserOut();
    }
  }

  int i=0;
  void _kickUserOut() {
    if(i==0){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
            title:Text("Don't Swipe up or Back in Test"),
          content: Image.asset("assets/images.jpeg"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK, I will take care'),
            ),
          ],
        ),
      );
      i+=1;
      return ;
    }
    Navigator.pop(context);
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Terminated !'),
        content: const Text('More than 1 MalAction Detected'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Send.bg,
          title: Text('${widget.quizId} Test',style: TextStyle(color: Colors.white),),
        ),
        body: FutureBuilder<List<QuizQuestion>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No questions found for this quiz.'));
            }
            if (_questions.isEmpty) {
              _questions = snapshot.data!;
              _startTimer(_questions.first.Timequiz);
            }
            final currentQuestion = _questions[_currentQuestionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '   Time Remaining : $_timeRemaining seconds',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '   Question ${_currentQuestionIndex + 1}/${_questions.length}:',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currentQuestion.question,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      final option = currentQuestion.options[index];
                      final isSelected = _selectedOptions[_currentQuestionIndex] == index; // Check if the current option is selected
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedOptions[_currentQuestionIndex] = index; // Update selected option
                            });
                            Future.delayed(Duration(seconds: 1), () {
                              _moveToNextQuestion(skipped: false);
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.black, // Highlight if selected
                                width: 1,
                              ),
                              color: isSelected ? Colors.blue.shade100 : Colors.white, // Optional background for selection
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.green : Colors.grey,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: Icon(
                                    isSelected ? Icons.check : Icons.square_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                    onTap: (){
                      _moveToNextQuestion(skipped: true);
                    },
                    child: Center(child: Send.see(w, "Skip Question", Icon(Icons.skip_next,color: Colors.white,)))),
                SizedBox(height: 14,)
              ],
            );
          },
        ),
      ),
    );
  }
}
