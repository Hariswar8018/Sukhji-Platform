class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOption;
  final String id;
   int Timequiz;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOption,
    required this.id,
    required this.Timequiz
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'id':id,
      'correctOption': correctOption,
      'Timequiz':Timequiz
    };
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] ?? 'Whats captal of India',
      options: List<String>.from(map['options'] ?? ['Delhi','Mumbai','Bombay','Chennai']),
      correctOption: map['correctOption'] ?? 0,
      Timequiz:map['Timequiz']??10,
      id:map['id']??"",
    );
  }
}
