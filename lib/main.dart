import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ignou_bscg/firebase_options.dart';
import 'package:ignou_bscg/first/login.dart';
import 'package:ignou_bscg/home/navigation.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.debug,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Sukhji Platforms',
        debugShowCheckedModeBanner:false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Splash(),
      ),
    );
  }
}


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future<void> checkAdminStatus(BuildContext context) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('ADMINS').doc('ADMINS').get();
      if (doc.exists) {
        bool isOn = doc.data()?['on'] ?? true;
        if (!isOn) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text("App Disabled"),
              content: const Text("This app is temporarily disabled by the admin."),
              actions: [
                TextButton(
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      SystemNavigator.pop(); // This will close the app
                      Future.delayed(const Duration(seconds: 1), () => Navigator.of(context).pop());
                    });
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }else{
          nowsend();
        }
      }else{
        nowsend();
      }
    } catch (e) {
      nowsend();
      print("Error fetching admin status: $e");
    }
  }

  void nowsend(){
    Timer(Duration(seconds : 3), (){
      User? user = FirebaseAuth.instance.currentUser ;
      if ( user == null ){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navigation()));
      }
    });
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  void initState(){
    super.initState();
    checkAdminStatus(context);
  }
  Future<void> updateAdminStatus(bool value) async {
    try {
      await FirebaseFirestore.instance.collection('ADMINS').doc('ADMINS').set({'on': value});
      print('Admin status updated to $value');
    } catch (e) {
      print('Failed to update admin status: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Container(
        color: Color(0xff8C1528),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image(
            image: AssetImage('assets/logo.jpg'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

