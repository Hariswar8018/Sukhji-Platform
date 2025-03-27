import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  TransactionModel({
    required this.answer,
    required this.name,
    required this.method,
    required this.rupees,
    required this.pay,
    required this.status,
    required this.coins,
    required this.time,
    required this.time2,
    required this.nameUid,
    required this.id,
    required this.pic,
    required this.transactionId,
  });

  late final bool answer;
  late final String name;
  late final String method;
  late final double rupees;
  late final bool pay;
  late final String status;
  late final int coins;
  late final String time; // You can change this to DateTime if needed
  late final String time2; // You can change this to DateTime if needed
  late final String nameUid;
  late final String id;
  late final String pic;
  late final String transactionId; // New field added

  TransactionModel.fromJson(Map<String, dynamic> json) {
    answer = json['answer'] ?? false;
    name = json['name'] ?? '';
    method = json['method'] ?? '';
    rupees = json['rupees']?.toDouble() ?? 0.0;
    pay = json['pay'] ?? false;
    status = json['status'] ?? '';
    coins = json['coins'] ?? 0;
    time = json['time'] ?? '';
    time2 = json['time2'] ?? '';
    nameUid = json['nameUid'] ?? '';
    id = json['id'] ?? '';
    pic = json['pic'] ?? '';
    transactionId = json['transactionId'] ?? ''; // New field added
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['answer'] = answer;
    data['name'] = name;
    data['method'] = method;
    data['rupees'] = rupees;
    data['pay'] = pay;
    data['status'] = status;
    data['coins'] = coins;
    data['time'] = time;
    data['time2'] = time2;
    data['nameUid'] = nameUid;
    data['id'] = id;
    data['pic'] = pic;
    data['transactionId'] = transactionId; // New field added
    return data;
  }

  static TransactionModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TransactionModel.fromJson(snapshot);
  }
}
