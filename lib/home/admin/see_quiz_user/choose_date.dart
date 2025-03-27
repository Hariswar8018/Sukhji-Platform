import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/quiz/add/add_quiz_id.dart';
import 'package:ignou_bscg/quiz/home/small_card.dart';

class ChooseDate extends StatefulWidget {
  DateTime uno;
  ChooseDate({super.key,required this.uno});

  @override
  State<ChooseDate> createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
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
        actions: [
          InkWell(
            onTap: (){
              DatePickerBdaya.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2022,1,1),
                  maxTime: DateTime(2080, 6, 7),
                  onChanged: (date) {
                    setState(() {
                      widget.uno=date;
                    });
                  }, onConfirm: (date) {
                    setState(() {
                      widget.uno=date;
                    });
                  }, currentTime: DateTime.now(),
                  locale: LocaleType.en);
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(child: Icon(Icons.calendar_month,color: Colors.black,),),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,)
        ],
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
              final todayDateString = widget.uno.toString().split(' ')[0]; // Format: YYYY-MM-DD
              final data = snapshot.data!.docs.where((doc) {
                final id = doc['id'] ?? '';
                return id.contains(todayDateString);
              }).toList();

              if (data.isEmpty) {
                return Center(child: Text('No data available for ${widget.uno}'));
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