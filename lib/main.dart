import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';


import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ignou_bscg/firebase_options.dart';
import 'package:ignou_bscg/first/login.dart';
import 'package:ignou_bscg/home/navigation.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
/*

Navigator.push(context, MaterialPageRoute(builder: (context) => Navigation()));

 */
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  void initState(){
    super.initState();
    Timer(Duration(seconds : 3), (){
      User? user = FirebaseAuth.instance.currentUser ;
      if ( user == null ){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navigation()));
      }
    });
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

