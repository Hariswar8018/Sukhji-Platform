class QuizTypeModel {
  final String id;
  final String dateTime;
  final String timeName;
  final String orderNumber;
  final String description;
  final String instruction;
  final int marks;
  final String qName;
  final String winning;
  final List<String> questions;
  final int spots;
  final List<String> registered;
  final int price;

  QuizTypeModel({
    required this.id,
    required this.marks,
    required this.dateTime,
    required this.timeName,
    required this.orderNumber,
    required this.description,
    required this.instruction,
    required this.qName,
    required this.winning,
    required this.questions,
    required this.spots,
    required this.registered,
    required this.price,
  });

  /// Convert QuizTypeModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime,
      'timeName': timeName,
      'marks': marks,
      'orderNumber': orderNumber,
      'description': description,
      'instruction': instruction,
      'qName': qName,
      'winning': winning,
      'questions': questions,
      'spots': spots,
      'registered': registered,
      'price': price,
    };
  }

  /// Create QuizTypeModel from Firestore JSON
  factory QuizTypeModel.fromJson(Map<String, dynamic> json) {
    return QuizTypeModel(
      id: json['id'] ?? '',
      dateTime: json['dateTime'] ?? '',
      timeName: json['timeName'] ?? '',
      marks: json['marks'] ?? 2,
      orderNumber: json['orderNumber'] ?? '10',
      description: json['description'] ?? '',
      instruction: json['instruction'] ?? '',
      qName: json['qName'] ?? '',
      winning: json['winning'] ?? '',
      questions: List<String>.from(json['questions'] ?? []),
      spots: json['spots'] ?? 50000,
      registered: List<String>.from(json['registered'] ?? ['As','asd','dgffggf','xfcgfgc','gfgfg']),
      price: json['price'] ?? 0,
    );
  }
}
