
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignou_bscg/game/pay.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/game.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;
import 'package:uuid/uuid.dart';

import '../home/admin/edit_prize.dart';
import '../model/user_scores.dart' as df;
import '../model/usermodel.dart';
import '../quiz/home/open_quiz.dart';
import '../quiz/home/scores.dart';
import 'about_game.dart';
import 'all_games.dart';
import 'game_score_cards.dart';


class GameFull extends StatefulWidget {
  int review ; bool ludo;
  GameFull({required this.game, required this.overed, this.admin=false, this.review=0,required this.ludo});
  bool overed;GameModel game;bool admin;
  @override
  State<GameFull> createState() => _GameFullState();
}

class _GameFullState extends State<GameFull> {
  late bool islive;

  List<UserModel> _listt = [];

  late Map<String, dynamic> userMap;

  late Map<String, dynamic> userMap2;

  late bool isovered;

  void initState(){
    if(status()!=statuscode.end||status()!=statuscode.await){
      islive=false;
      isovered=true;setState(() {

      });
    }else if(status()==statuscode.live){
      islive=true;
      isovered=false;setState(() {

      });
    }else if(status()==statuscode.upcoming){
      islive=false;
      isovered=false;setState(() {

      });
    }

  }

  @override
  Widget build(BuildContext context){
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return status()==statuscode.end||widget.admin?
    Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7429E8),
        title: Text("Game Screen",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                AboutGame(game: widget.game,)));
          }, child:Text("Instructions",style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/Comp_2.gif",width: w,fit: BoxFit.contain,),
          Container(
            color: Color(0xff7429E8),width: w,height: 40,
            child: Center(child: Text(widget.game.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 18.0,bottom: 8),
            child: Center(
              child: Container(
                  width: w-23,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Color(0xff7429E8),
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
          widget.review==0?about(context, w):Container(
            width: w,
            height: h - 400,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection(widget.ludo?"LUDO":"CARROM").doc(widget.game.id).collection("Players")
                  //.orderBy("score", descending: true) // Ensures highest score is first
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _listt = data
                        ?.map((e) => UserModel.fromJson(e.data()))
                        .toList() ??
                        [];
                    if(_listt.isEmpty){
                      return Center(
                        child: Text("No User took part in Tournament"),
                      );
                    }
                    return ListView.builder(
                      itemCount: _listt.length,
                      padding: EdgeInsets.only(top: 10),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            width: w-20,
                            height: 100,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow,
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("# 1",style: TextStyle(fontWeight: FontWeight.w800),),
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(_listt[0].pic),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name",style: TextStyle(fontWeight: FontWeight.w800),),
                                    Text(formatTo17Words(_listt[0].Name,12),style: TextStyle(fontWeight: FontWeight.w400),),
                                    widget.admin?Text(convertToShortUUID(_listt[0].uid)):SizedBox(),
                                  ],
                                ),
                                SizedBox(width: 15,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Points Collected",style: TextStyle(fontWeight: FontWeight.w800),),
                                    Text(formatTo17Words(_listt[0].prizepoints.toStringAsFixed(1),4),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.red),),
                                  ],
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    if(widget.admin){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>Pay_Winners(game_id: widget.game.id, userid: _listt[0].uid,
                                            username: _listt[0].Name, ludo: widget.ludo,)));
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      widget.admin?Icon(Icons.edit,color: Colors.green,):Text("Win",style: TextStyle(fontWeight: FontWeight.w800),),
                                      Text("₹"+_listt[0].prizewins.toString(),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                          );
                        } else {
                          return ScoresCards(
                            quiz: _listt[index],isadmin: widget.admin,quid: widget.game.id,ludo: widget.ludo,
                            indexx: index,
                          );
                        }
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    ):

    Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7429E8),
        title: Text("Game Screen",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: InkWell(
            onTap: () async {
              if(status()==statuscode.live){
                final Uri _url = Uri.parse(widget.game.gameLink);
                if (!await launchUrl(_url)) {
              throw Exception('Could not launch $_url');
              }
              }else{
                Send.message(context, "Wait fo the Game to become LIVE", false);
              }
            },
            child: Container(
              width: w-30,
              height: 50,
              decoration: BoxDecoration(
                  color:!(status()==statuscode.live)?Colors.grey.shade500:Colors.white,
                  borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: status()==statuscode.live?Colors.blue:Colors.transparent,
                  width: 2
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Launch Game",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
                  SizedBox(width: 10,),
                  Icon(Icons.open_in_new_off),SizedBox(width: 7,),
                ],
              ),
            ),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/Comp_2.gif",width: w,fit: BoxFit.contain,),
          Container(
            color: Color(0xff7429E8),width: w,height: 40,
            child: Center(child: Text(widget.game.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
          ),
         about(context, w),
        ],
      ),
    );
  }
  String convertToShortUUID(String str) {
    var uuid = Uuid();
    print(str);
    // Use UuidNamespaces.url instead of the deprecated constant
    return uuid.v5(Uuid.NAMESPACE_URL, str).substring(0,10); // Shortened
  }
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
        color: yes==widget.review?Colors.white:Color(0xff7429E8),
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
      return "Details";
    }else if(y==1){
      return "Leaderboards";
    }else {
      return "Invites";
    }
  }

  Widget about(BuildContext context , double w){
    return  Container(
      width: w,height: 360,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("# 1 . Download Game from PlayStore",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("App Name : ${widget.game.appDownloadLink}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
            ),
            InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse(widget.game.appLink);
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: Image.asset("assets/google-play-badge.png",width: w/2,)),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("# 2. Change your Name to :",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Icon(Icons.person,color: Colors.blue,),
                  SizedBox(width: 9,),
                  Text("Your Name must be exactly as provided below !",style: TextStyle(color: Colors.red),)
                ],
              ),
            ),
            copy(context, convertToShortUUID(FirebaseAuth.instance.currentUser!.uid)),
            SizedBox(height: 24,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("# 3. Join the Game :",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
            ),SizedBox(height: 10,),


            status()==statuscode.upcoming?QuizCountdown(quizId: widget.game.startTime):SizedBox(),


            status()==statuscode.live?Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Game link : ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
            ):SizedBox(),
            status()==statuscode.live?copy(context, widget.game.gameLink):SizedBox(),
            status()==statuscode.live?SizedBox(height: 20,):SizedBox(),
            status()==statuscode.live?Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Room ID : ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
            ):SizedBox(),
            status()==statuscode.live?copy(context, widget.game.gameLinkId):SizedBox(),
            status()==statuscode.live?SizedBox(height: 10,):SizedBox(),
            status()==statuscode.live?Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Room Password ( if any ) : ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
            ):SizedBox(),
            status()==statuscode.live?copy(context, widget.game.gameLinkPassword):SizedBox(),
            SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }
  statuscode status(){
    DateTime now = DateTime.now();
    DateTime start = DateTime.parse(widget.game.startTime);
    DateTime end = DateTime.parse(widget.game.endTime);
    DateTime result = DateTime.parse(widget.game.resultTime);

    if(now.isAfter(result)){
      return statuscode.end;
    }else if( now.isAfter(end) && now.isBefore(result)){
      return statuscode.await;
    }else if(now.isAfter(start)&&now.isBefore(end)){
      return statuscode.live;
    }else{
      return statuscode.upcoming;
    }
  }

  String formatTo17Words(String input,int i) {
    // If the input is shorter than 17 characters, pad it with spaces
    if (input.length < i) {
      return input.padRight(i, ' ');
    }

    // If the input is longer than 17 characters
    // Split the input into words
    List<String> words = input.split(' ');
    String result = '';

    // Build the result word by word until it reaches 17 characters
    for (String word in words) {
      if ((result + word).length <= i) {
        result += (result.isEmpty ? '' : ' ') + word;
      } else {
        break;
      }
    }

    // Pad the result with spaces to ensure it's exactly 17 characters
    return result.padRight(i, ' ');
  }

  Widget copy(BuildContext context,String link){
    double w=MediaQuery.of(context).size.width;
    return Center(
      child: InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: link));
          Send.message(context, "Copied to Clipboard !", true);
        },
        child: Container(
          width: w-20,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.grey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8,),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(Icons.copy,size: 30,),
              ), SizedBox(width: 8,),
              Center(child: Text(link,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: w/23),),),
            ],
          ),
        ),
      ),
    );
  }
}