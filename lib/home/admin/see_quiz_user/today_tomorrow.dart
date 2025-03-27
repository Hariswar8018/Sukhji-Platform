import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/quiz/add/add_quiz_id.dart';
import 'package:ignou_bscg/quiz/home/small_card.dart';

import '../../../global/send.dart';

class Today extends StatelessWidget {
  const Today({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Send.bg,
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuizId()));
        },
        child: Icon(Icons.add,color: Colors.white,),),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Send.bg,
        automaticallyImplyLeading: true,
        title: Text("Today Quiz",style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No data available for today.'));
              }
              final todayDateString = DateTime.now().toString().split(' ')[0]; // Format: YYYY-MM-DD
              final data = snapshot.data!.docs.where((doc) {
                final id = doc['id'] ?? '';
                return id.contains(todayDateString);
              }).toList();

              if (data.isEmpty) {
                return Center(child: Text('No data available for today.'));
              }

              final list = data
                  .map((e) => QuizTypeModel.fromJson(e.data()))
                  .toList();

              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    quiz: list[index],isadmin: true,
                  );
                },
              );
          }
        },
      ),
    );
  }
}
class Tomorrow extends StatelessWidget {
  const Tomorrow({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Send.bg,
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuizId()));
        },
        child: Icon(Icons.add,color: Colors.white,),),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Send.bg,
        automaticallyImplyLeading: true,
        title: Text("Today Quiz",style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No data available for tomorrow.'));
              }

              // Get tomorrow's date in YYYY-MM-DD format
              final tomorrowDateString = DateTime.now()
                  .add(Duration(days: 1))
                  .toString()
                  .split(' ')[0]; // Format: YYYY-MM-DD

              // Filter documents where the id contains tomorrow's date
              final data = snapshot.data!.docs.where((doc) {
                final id = doc['id'] ?? '';
                return id.contains(tomorrowDateString);
              }).toList();

              if (data.isEmpty) {
                return Center(child: Text('No data available for tomorrow.'));
              }

              // Map filtered documents to QuizTypeModel
              final list = data
                  .map((e) => QuizTypeModel.fromJson(e.data()))
                  .toList();

              // Build ListView
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    quiz: list[index],isadmin: true,
                  );
                },
              );
          }
        },
      ),
    );
  }
}
