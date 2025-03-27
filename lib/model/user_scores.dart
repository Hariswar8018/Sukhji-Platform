import 'package:ignou_bscg/model/quiz.dart';

class UserScore {
  final List<QuizQuestion> questions;
  final double score;
  final String completedAt;
  final bool isLive;
  final int fullMarks;
  final double negativeMarks;
  final int noCorrect;
  final int noWrong;
  final int noSkip;
  final String name;
  final String pic;
  final String address;
  String prizewin;
  String id;

  UserScore({
    required this.questions,
    required this.name,
    required this.id,
    required this.pic,
    required this.address,
    required this.score,
    required this.completedAt,
    required this.isLive,
    required this.fullMarks,
    required this.negativeMarks,
    required this.noCorrect,
    required this.noWrong,
    required this.noSkip,
    required this.prizewin
  });

  Map<String, dynamic> toMap() {
    return {
      'questions': questions.map((q) => q.toMap()).toList(),
      'score': score,
      'id':id,
      'completedAt': completedAt,
      'isLive': isLive,
      'name': name,
      'pic': pic,
      'address': address,
      'fullMarks': fullMarks,
      'negativeMarks': negativeMarks,
      'noCorrect': noCorrect,
      'noWrong': noWrong,
      'noSkip': noSkip,
      'prizewin':prizewin,
    };
  }

  factory UserScore.fromJson(Map<String, dynamic> map) {
    return UserScore(
      questions: (map['questions'] as List<dynamic>)
          .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      score: (map['score'] ?? 0).toDouble(),
      name: map['name'] ?? "",
      pic: map['pic'] ?? "",
      id:map['id']??"",
      address: map['address'] ?? "",
      prizewin: map['prizewin']??"0",
      completedAt: map['completedAt'] ?? '',
      isLive: map['isLive'] ?? false,
      fullMarks: map['fullMarks'] ?? 0,
      negativeMarks: (map['negativeMarks'] ?? 0).toDouble(),
      noCorrect: map['noCorrect'] ?? 0,
      noWrong: map['noWrong'] ?? 0,
      noSkip: map['noSkip'] ?? 0,
    );
  }
}
