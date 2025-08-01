import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart' show ProgressBar;

import '../global/send.dart';
import '../home/second/second.dart';
import '../model/game.dart';
import '../model/transaction.dart';
import '../model/usermodel.dart';
import '../providers/declare.dart';
import 'about_game.dart';
import 'game_full_card.dart';
import 'make_game.dart';
enum statuscode{end, await, live, upcoming}
class AllGamesUpars extends StatefulWidget {
  bool ludo;
  int review;

  bool admin;
  AllGamesUpars({super.key,required this.ludo,this.review=0,required this.admin});

  @override
  State<AllGamesUpars> createState() => _AllGamesUparsState();
}

class _AllGamesUparsState extends State<AllGamesUpars> {
  
  void initState(){
    game_name=widget.ludo?"LUDO":"CARROM";
  }
  String game_name="";
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton:!widget.admin?SizedBox(): FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => GameInputScreen(ludo: widget.ludo,)));
      },child: Icon(Icons.add,color: Colors.white,),backgroundColor: Colors.blue,),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Color(0xff7429E8),
        automaticallyImplyLeading: true,
        title: Text(widget.ludo?"Ludo Game":"Carrom Game",style: TextStyle(color: Colors.white),),
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
          Container(
            width: w,
            height: 550,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection(widget.ludo?"LUDO":"CARROM").snapshots(),
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
                    final now = DateTime.now();

                    final data = snapshot.data!.docs.where((doc) {
                      final formattedString = doc['resultTime'];
                      final Timestamp endTimeStamp = Timestamp.fromDate(DateTime.parse(formattedString));
                      final DateTime endTime = endTimeStamp.toDate();
                      if (widget.review==1) {
                        return endTime.isBefore(now);
                      } else {
                        return endTime.isAfter(now);
                      }
                    }).toList();

                    if (data.isEmpty) {
                      return Center(child: Text('No data available for today.'));
                    }

                    final list = data
                        .map((e) => GameModel.fromJson(e.data()))
                        .toList();

                    return ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: 10),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserr(
                          game: list[index],ludo: widget.ludo,admin: widget.admin,
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
      return "Upcomings";
    }else if(y==1){
      return "Past Games";
    }else {
      return "Invites";
    }
  }
}

class ChatUserr extends StatelessWidget {

  bool ludo, admin;
  ChatUserr({super.key, required this.game, required this.ludo, required this.admin});
  GameModel game;



  bool isOvered(GameModel game) {
    try {
      final now = DateTime.now();
      if (now.isAfter(DateTime.parse(game.resultTime))) {
        return true;
      }
      return false;
    } catch (e) {
      return true;
    }
  }

  bool isLive(GameModel game) {
    try {
      final now = DateTime.now();
      if (now.isAfter(DateTime.parse(game.resultTime))) {
        return true;
      }
      return false;
    } catch (e) {
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w=MediaQuery.of(context).size.width;
    return Card(
      child: InkWell(
        onDoubleTap: () async{
          await FirebaseFirestore.instance.collection(ludo?"LUDO":"CARROM").doc(game.id).delete();
        },
        onTap: (){
          String id = FirebaseAuth.instance.currentUser!.uid;
          if(admin){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                GameFull(game: game, overed: isOvered(game),admin: true, ludo: ludo,)));
            return ;
          }
          
          if(status()==statuscode.end){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                GameFull(game: game, overed: isOvered(game),ludo: ludo,)));
          }else if(status()==statuscode.await){
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  width: w,
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Awaiting Result',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                      Image.asset("assets/result.png",width: w/3-40,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0,right: 18),
                        child: Text('Result will be shared on ${declare(game.resultTime)}',textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          }else {
            if(game.players.contains(id)){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  GameFull(game: game, overed: isOvered(game),ludo: ludo,)));
            }else{
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: w,
                    color: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${game.price}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: Text('Pay ₹${game.price} to Enter this Tournament and fight with Participants',textAlign: TextAlign.center,),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                            onTap: () async {
                              try {
                                if (_user == null || game == null) {
                                  Send.message(context, "Unexpected error occurred. Please try again.", false);
                                  return;
                                }
                                if (_user!.amount >= game.price) {
                                  Navigator.pop(context);
                                  f(context, _user);
                                } else {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Wallet()));
                                  Send.message(context, "You don't have enough money in your wallet.", false);
                                }
                              } catch (e) {
                                Navigator.pop(context);
                                Send.message(context, "Error: $e", false);
                              }
                            },

                            child: Send.see(w, "Pay & Continue", Icon(Icons.payments,color: Colors.white,)))
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
        child: Container(
          width: w-20,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: w,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(ludo?"assets/ludo.jpg":"assets/carrom.png",width: 90,),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(game.name,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),),
                        Text("Game Start Time : ${declare(game.startTime)}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: w/40,color: Colors.black),),
                        Text("Game End Time   : ${declare(game.endTime)}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: w/40,color: Colors.black),),
                        Text("Result Time          : ${declare(game.resultTime)}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: w/40,color: Colors.black),),

                        Container(
                            width: w/2,
                            color: Color(0xff7429E8),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6,bottom: 6,left: 10,right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.diamond,color: Colors.white,size: 20,),
                                  SizedBox(width: 7,),
                                  Text("Winning Prize : ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/35,color: Colors.white),),
                                  Text("₹ ${game.winning}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: w/35,color: Colors.white),),
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: w-20,
                child: Row(
                  children: [
                    Container(
                      width: w-80,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0,right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${game.players.length.toString()} Registered",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/40,color: Colors.red),),
                                Spacer(),
                                Text("${(game.spots-game.players.length)} Spot Left",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/40,color: Colors.indigo),),
                              ],
                            ),
                          ),
                          SizedBox(height: 3,),
                          Container(
                            width: w-80,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0,right: 15),
                              child: ProgressBar(
                                value: (game.players.length/game.spots),
                                height: 5,
                                color: Colors.red,backgroundColor: Colors.grey.shade200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(3)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10,top: 4,bottom: 4),
                        child: Text("₹ ${game.price}",style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          AboutGame(game: game,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                      child: Container(
                        width: w/3,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("About Game",style: TextStyle(fontSize: w/40,fontWeight: FontWeight.w800),)),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                      child: Container(
                        width: w/3,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("${(status().name).toUpperCase()}",style: TextStyle(fontSize: w/40,fontWeight: FontWeight.w800),)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }



  statuscode status(){
    DateTime now = DateTime.now();
    DateTime start = DateTime.parse(game.startTime);
    DateTime end = DateTime.parse(game.endTime);
    DateTime result = DateTime.parse(game.resultTime);

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


  String declare(String ids) {
    try {
      DateTime quizDateTime = DateTime.parse(ids);
      DateTime now = DateTime.now();

      // Normalize dates to compare just the date part
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime tomorrow = today.add(Duration(days: 1));
      DateTime quizDate = DateTime(quizDateTime.year, quizDateTime.month, quizDateTime.day);

      String time = "${quizDateTime.hour.toString().padLeft(2, '0')}:${quizDateTime.minute.toString().padLeft(2, '0')}";

      if (quizDate == today ) {
        return time; // Just time
      }else if ( quizDate == tomorrow) {
        return time + " Tomorrow"; // Just time
      }  else {
        return "$time on ${quizDateTime.day}/${quizDateTime.month}"; // Time with date
      }
    } catch (e) {
      return "10:30 AM";
    }
  }

  void f(BuildContext context, UserModel _user) {
    double w = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      isDismissible: false, // Prevent dismissal
      enableDrag: false, // Disable drag-to-close
      builder: (BuildContext modalContext) {
        // Start the async operation after showing the modal
        WidgetsBinding.instance.addPostFrameCallback((_) {
          yesgoing(modalContext, context, _user);
        });

        return Container(
          width: w,
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Paying & Registering',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 20),
              Center(child: CircularProgressIndicator()),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Text(
                  'Do not Press Back or Close App',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> yesgoing(BuildContext modalContext, BuildContext parentContext, UserModel _user) async {
    try {
      // Deduct amount from user's balance
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_user.uid)
          .update({
        "amount": FieldValue.increment(-game.price),
      });

      // Update registered users in Quiz collection
      await FirebaseFirestore.instance.collection(ludo?"LUDO":"CARROM").doc(game.id).update({
        "players": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });

      await FirebaseFirestore.instance.collection(ludo?"LUDO":"CARROM").doc(game.id).collection("Players").doc(_user.uid).set(_user.toJson());

      UserProvider _userProvider = Provider.of(parentContext, listen: false);
      await _userProvider.refreshuser();

      // Close the modal sheet
      Navigator.pop(modalContext);

      // Show success message
      Send.message(parentContext, "Success! You entered the contest.", true);
      sendd();
    } catch (e) {
      // Handle errors and still close the modal sheet
      Navigator.pop(modalContext);
      Send.message(parentContext, "An error occurred while entering the contest.", false);
    }
  }

  sendd() async {
    try {
      String str = DateTime.now().toString();
      TransactionModel tran = TransactionModel(answer: true,
          name: game.name,
          method: "",
          rupees: game.price.toDouble(),
          pay: true,
          status: "Debited",
          coins: game.price.toInt(),
          time: str,
          time2: game.id,
          nameUid: "Transaction Debited",
          id: str,
          pic: "",
          transactionId: ""
      );
      await FirebaseFirestore.instance.collection("users").doc(
          FirebaseAuth.instance.currentUser!.uid).collection("Transaction")
          .doc(str).set(tran.toJson());
    }catch(e){

    }

  }
}
