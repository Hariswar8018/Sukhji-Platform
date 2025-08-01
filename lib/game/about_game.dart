import 'package:flutter/material.dart';
import 'package:ignou_bscg/model/game.dart';

import '../global/send.dart';

class AboutGame extends StatefulWidget {
  var review=0;GameModel game;
   AboutGame({super.key,this.review=0, required this.game});

  @override
  State<AboutGame> createState() => _AboutGameState();
}

class _AboutGameState extends State<AboutGame> {
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7429E8),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: Text("Important Instructions",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Game Start Time : ${declare(widget.game.startTime)}",
                style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Game End Time : ${declare(widget.game.endTime)}",
                style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Game Result Time : ${declare(widget.game.endTime)}",
                style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: w/2,
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6,bottom: 6,left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.diamond,color: Colors.white,size: 20,),
                        SizedBox(width: 7,),
                        Text("Winning Prize : ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/35,color: Colors.white),),
                        Text("₹ ${widget.game.winning}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: w/35,color: Colors.white),),
                      ],
                    ),
                  )),
            ),
            SizedBox(height: 7,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                    width: w-20,
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
                        ],
                      ),
                    )
                ),
              ),
            ),
            widget.review==0?descri():Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.game.description),
            )
          ],
        ),
      ),
    );
  }
  String declare(String ids){
    try {
      DateTime quizDateTime = DateTime.parse(ids);
      return "${quizDateTime.hour}:${quizDateTime.minute} on ${quizDateTime.day}/${quizDateTime.month}";
    }catch(e){
      return "10:30 AM";
    }
  }
  Widget descri(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          q('''Enjoy fun and engaging games like Carrom, Ludo, and Quiz now on Sukhji Platform! Compete with friends or join hosted events to win exciting rewards.'''),
          a("📜 Game Policy"),
          q('''
Games may be hosted by Sukhji on selected days.      
Users must join with the Host ID provided in the app.      
Users must change their in-game name to the exact name shown in the app to be eligible.      
Rewards (if any) are only given to those who follow all instructions.  
Any kind of cheating or misbehavior will lead to disqualification.
      
          '''),
          a("📋 Instructions to Play"),
          q('''
Open Sukhji Platform and check for any Game Day announcements.      
Note the Host ID and Player Name shown in the app.     
Open the game (Carrom/Ludo/Quiz) and:    
Join with Host ID.      
Change your player name to the exact name provided.      
Play fairly and enjoy!
      
      Winners will be verified and rewarded as per policy.
          ''')
        ],
      ),
    );
  }
  Widget a(String str){
    return Text(str,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.blue),);
  }
  Widget q(String str){
    return Text(str,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),);
  }
  String instruction = '''
  
  ''';

  Widget f(double w, int yes)=>InkWell(
    onTap: (){
      setState(() {
        widget.review=yes;
      });
      print(widget.review);
    },
    child: Container(
      width: w/2-20,
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

  String yiop(int y){
    if(y==0){
      return "Description";
    }else if(y==1){
      return "Instruction";
    }else {
      return "Invites";
    }
  }
}
