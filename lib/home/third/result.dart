import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz_type.dart';

import '../../quiz/home/small_card.dart';

class Result extends StatefulWidget {
  bool showback;int review;
Result({super.key,required this.showback,this.review=0});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Send.bg,
        automaticallyImplyLeading: widget.showback,
        title: Text("Check Results",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 18.0,bottom: 8),
            child: Center(
              child: Container(
                  width: w-23,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Send.bg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      // specify the radius for the top-left corner
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      // specify the radius for the top-right corner
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        f(w, 0),
                        f(w, 1),
                        f(w, 2),
                      ],
                    ),
                  )
              ),
            ),
          ),
          Container(
            height: h-200,
            width: w,
            child: StreamBuilder(
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
                    final tomorrowyDateString = DateTime.now()
                        .subtract(Duration(days: 2))
                        .toString()
                        .split(' ')[0];
                    final tomorrowDateString = DateTime.now()
                        .subtract(Duration(days: 1))
                        .toString()
                        .split(' ')[0]; // Format: YYYY-MM-DD
                    final todayDateString = DateTime.now().toString().split(' ')[0]; // Format: YYYY-MM-DD
                    final data = snapshot.data!.docs.where((doc) {
                      final id = doc['id'] ?? '';
                      return widget.review==1?id.contains(tomorrowDateString):(widget.review==2?id.contains(tomorrowyDateString):id.contains(todayDateString));
                    }).toList();
                    if (data.isEmpty) {
                      return Center(child: Text(widget.review==0?'No data available for today':(widget.review==1?"No data available for Yesterday":"No data available for Day before Yesterday")));
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
                          quiz: list[index],isadmin: false,review: 1,
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String yiop(int y){
    if(y==0){
      return "Today";
    }else if(y==1){
      return "Yesterday";
    }else {
      return "Day before Y";
    }
  }

  Widget f(double w, int yes)=>InkWell(
    onTap: (){
      setState(() {
        widget.review=yes;
      });
      print(widget.review);
    },
    child: Container(
      width: w/3-20,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: yes==widget.review?Colors.white:Send.bg,
      ),
      child: Center(
        child: Text(yiop(yes),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: yes==widget.review?Colors.black:Colors.white)),
      ),
    ),
  );
}
