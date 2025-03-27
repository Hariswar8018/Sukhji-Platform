
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ignou_bscg/home/admin/navigation.dart';
import 'package:ignou_bscg/home/home.dart';
import 'package:ignou_bscg/home/leaderboard.dart';
import 'package:ignou_bscg/home/profile.dart';
import 'package:ignou_bscg/home/third/result.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class Navigation extends StatefulWidget {
  Navigation({super.key});

  @override
  State<Navigation> createState() => _HomeState();
}

class _HomeState extends State<Navigation> {
  void v1() async{
    int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String formattedDate = DateFormat('MMM d, HH:mm').format(dateTime);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "lastlogin": formattedDate,
    });
    print(formattedDate);
  }
  void g() async{
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      CollectionReference collection =
      FirebaseFirestore.instance.collection('users');
      String? token = await _firebaseMessaging.getToken();
      print(token);
      if (token != null) {
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({
          'token': token,
        });
        _firebaseMessaging.requestPermission();
      }
    }catch(e){
      print(e);    }
  }
  void initState(){
    v();v1();g();
  }

  v() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser(); // Call refreshuser() to update _user
    if (_userprovider.getUser != null) {
      print("Got you");
      print(_userprovider.getUser!.uid);
    } else {
      print("User is null");
    }
  }


  Widget diu(){
    if(_currentIndex==1){
      return Result(showback: false);
    }else if(_currentIndex==2){
      return Profile();
    }
    return Home2();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit App"),
          content: Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Stay in the app
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Exit the app
              child: Text("Exit"),
            ),
          ],
        );
      },
    ) ?? false; // If the dialog is dismissed, return false (stay in the app)
    return exitApp;
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    String user=FirebaseAuth.instance.currentUser!.uid??"";
    bool b=false;//((user=="ugEMcDH9jwQE4EDiKok0cSQvHB42")||(user=="jYDRg96GalQKuyZOrBOq3l3FdWr2"));
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child:b? AdminNavigation() : sd(false));
  }

  String df(){
    if(_currentIndex==1){
      return "Live Location";
    }else if(_currentIndex==2){
      return "Bus Profile";
    }
    return "Home";
  }

  Widget admin(bool b){
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      body: diu(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex=index;
          setState(() {

          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Result",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        selectedItemColor: Colors.blueAccent, // Selected icon color
        unselectedItemColor: Colors.grey, // Unselected icon color
        backgroundColor: Colors.white, // Background color
      ),
    );
  }

  Widget sd(bool b){
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      body: diu(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex=index;
          setState(() {

          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Result",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        selectedItemColor: Colors.blueAccent, // Selected icon color
        unselectedItemColor: Colors.grey, // Unselected icon color
        backgroundColor: Colors.white, // Background color
      ),
    );
  }
  int _currentIndex = 0;
}
