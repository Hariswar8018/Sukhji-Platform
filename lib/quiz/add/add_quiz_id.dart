import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:ignou_bscg/function/notify_all.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/quiz/home/open_quiz.dart';

class AddQuizId extends StatefulWidget {
  AddQuizId({super.key});

  @override
  State<AddQuizId> createState() => _AddQuizIdState();
}

class _AddQuizIdState extends State<AddQuizId> {
  TextEditingController names=TextEditingController();
  TextEditingController winning=TextEditingController();
  TextEditingController price=TextEditingController();
  TextEditingController capacity=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
          automaticallyImplyLeading: true,
          backgroundColor: Send.bg,
          title: Text('Add New Quiz',style: TextStyle(color: Colors.white),
          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("   Name",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            r14(names, w, "General Knowledge",false),
            SizedBox(height: 10,),
            Text("   Winning Prize",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            r14(winning, w, "200",true),
            SizedBox(height: 10,),
            Text("   Price to Register",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            r14(price, w, "5",true),
            SizedBox(height: 10,),
            Text("   Total Capacity / Spot",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            r14(capacity, w, "100000",true),
            SizedBox(height: 10,),
            Text("   Time",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w, "8 AM",8),r1(w,"9 AM",9),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w, "10 AM",10),r1(w,"11 AM",11),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w, "12 PM",12),r1(w,"1 PM",13),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w, "2 PM",14),r1(w,"3 PM",15),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w, "4 PM",16),r1(w,"5 PM",17),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w, "6 PM",18),r1(w,"7 PM",19),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w, "8 PM",20),r1(w,"9 PM",21),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w, "10 PM",22),r1(w,"11 PM",23),
              ],
            ),
            SizedBox(height: 10,),
            Text("   Marks",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r12(w, 1),r12(w,2), r12(w, 3),r12(w,4),r12(w, 5),r12(w, 10),r12(w,20)
              ],
            ),
            SizedBox(height: 10,),
            Text("   Date",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: w/2+30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
                    child: TextField(
                      controller: co,
                      readOnly: true,
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
                        hintText: "Date",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12,),
                InkWell(
                  onTap: (){
                    DatePickerBdaya.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2080, 6, 7),
                        onChanged: (date) {
                          print('change $date');
                          setState(() {
                            s=date.toString();
                            co.text=date.day.toString() + " / "+date.month.toString()+" / "+date.year.toString();
                          });
                        }, onConfirm: (date) {
                          setState(() {
                            s=date.toString();
                            co.text=date.day.toString() + " / "+date.month.toString()+" / "+date.year.toString();
                          });
                        }, currentTime: DateTime.now(),
                        locale: LocaleType.en);
                  },
                  child: Container(
                    width: w/2-90,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Send.bg,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Center(child: Text("Select",style: TextStyle(color: Colors.white),)),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Text("   Description",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            r(name,w,"Enter Description"),
            SizedBox(height: 10,),
            Text("   Instructions for Candidates",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
            r(instructions,w,"Enter Instructions"),
          ],
        ),
      ),
      persistentFooterButtons: [
        Center(child: InkWell(
            onTap: () async {
              try {
                if(co.text.isEmpty){
                  Send.message(context, "Date not choosen", false);
                  return ;
                }
                if(name.text.isEmpty){
                  Send.message(context, "Description not Written", false);
                  return ;
                }
                String id = getr(s);
                if(capacity.text.isEmpty){
                  Send.message(context, "Capaity not Given", false);
                  return ;
                }if(price.text.isEmpty){
                  Send.message(context, "Price not Given", false);
                  return ;
                }
                int spots=int.parse(capacity.text)??12;
                int pri=int.parse(price.text)??12;
                QuizTypeModel quizz = QuizTypeModel(
                    id: id,
                    dateTime: s,
                    timeName: co.text,
                    orderNumber: ordernumber,
                    description: name.text,
                    instruction: instructions.text, marks: hj,
                    qName: names.text, winning: winning.text, questions: [], spots: spots, registered: [], price: pri);
                await FirebaseFirestore.instance.collection("Quiz").doc(id).set(quizz.toJson());
                notifyall(id);
                sendtofirebase(id);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => OpenQuiz(quiz: quizz, admin: true,)));
                Send.message(context, "Created", false);
              }catch(e){
                Send.message(context, "$e", false);
              }
            },
            child: Send.se(w, "Save & Continue"))),
      ],
    );
  }

  void sendtofirebase(String idi){
    DateTime targetDateTime = DateTime.parse(s);
    DateTime finalDateTime = DateTime(
      targetDateTime.year,
      targetDateTime.month,
      targetDateTime.day,
      int.parse(ordernumber), // your selected hour (e.g., 20 for 8 PM)
    );
    FirebaseFirestore.instance.collection('scheduled_classes').add({
      'title': '${names.text} Quiz Sheduled at ${day(idi)}',
      'description': 'Quiz will start Soon. Sukhji Platform will host Quiz on ${names.text} at ${day(idi)}',
      'targetDate': Timestamp.fromDate(finalDateTime), // Scheduled time
    });
    print("Sent");
  }

  void notifyall(String idi){
    NotifyAll.sendNotifications("${names.text} Quiz Sheduled at ${day(idi)}", "Sukhji Platform will host Quiz on ${names.text} at ${day(idi)}");
  }

  String day(idi){
    try {
      DateTime quizDateTime = DateTime.parse(idi);
      if(quizDateTime.hour<12){
        return quizDateTime.hour.toString() + ":00 AM";
      }
      if(quizDateTime.hour==12){
        return quizDateTime.hour.toString() + ":00 PM";
      }
      return (quizDateTime.hour - 12 ).toString() + ":00 PM";
    }catch(e){
      return "10:00 AM";
    }
  }
  int hj=2;
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
  String getr(String date) {
    // Example strings
    String dateTimeString = date; // Example DateTime string
    String hourString = ordernumber; // Example hour string (24-hour format)

    // Parse the dateTimeString
    DateTime parsedDate = DateTime.parse(dateTimeString);

    // Parse the hour string and create a new DateTime with combined hour
    int hour = int.parse(hourString);
    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      hour,
    );

    return combinedDateTime.toString();
  }
  String s="";String ordernumber="10";
  TextEditingController co=TextEditingController();
  TextEditingController instructions=TextEditingController();
  String name1="10 AM";

  Widget r1(double w,String str,int str1)=>InkWell(
    onTap: (){
      setState(() {
        name1=str;
        ordernumber=str1.toString();
      });
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: w/2-10,
        height: 50,
        decoration: BoxDecoration(
          color: name1==str?Colors.blue.shade50:Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
              color: name1==str?Colors.black:Colors.black,
              width: name1==str?3: 1
          ),
        ),
        child: Center(child: Text(str,style: TextStyle(fontWeight: FontWeight.w600),)),
      ),
    ),
  );

  TextEditingController name=TextEditingController();
  Widget r14(TextEditingController _controller,double w,String str,bool yrrt){
    return  Center(
      child: Container(
        width: w-10,
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
            keyboardType:yrrt?TextInputType.number: TextInputType.name,
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
  Widget r(TextEditingController _controller,double w,String str){
    return  Center(
      child: Container(
        width: w-10,
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
}
