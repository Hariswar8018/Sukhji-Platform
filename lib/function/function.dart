
import 'package:cloud_firestore/cloud_firestore.dart';

class SendF{
  static Future<void> scheduleClass({
    required String title,
    required String description,
    required DateTime targetDateTime,
  }) async {
    await FirebaseFirestore.instance.collection('scheduled_classes').add({
      'title': title,
      'description': description,
      'targetDate': targetDateTime.toUtc(), // store in UTC
      'forAll': true,
      'createdAt': DateTime.now().toUtc(),
    });
  }
}
