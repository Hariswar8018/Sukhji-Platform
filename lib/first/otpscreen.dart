import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/navigation.dart';
import 'package:ignou_bscg/home/user_profile.dart';
import 'package:ignou_bscg/main.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

class OtpLoginScreen extends StatefulWidget {
String verificationId; String phonenumber;

  OtpLoginScreen({required this.verificationId,required this.phonenumber});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool on=false;
  void _verifyOtp(BuildContext context) async {
    setState(() {
      on=true;
    });
    String otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      setState(() {
        on=false;
      });
      Send.message(context,"Enter a valid 6-digit OTP", false);
      return;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      print("--------------------------------------");
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print("---ss");
      final user = userCredential.user;
      if (user == null) {
        print("Sign-in failed: user is null");
        if (mounted) setState(() => on = false);
        Send.message(context, "Sign-in failed. Try again.", false);
        return;
      }
      String uid = user.uid;
      print("--------------------------------------$uid");

      try {
        CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
        QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo:uid).get();
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            on=false;
          });
          print("---------------------------SS-----------");

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Splash()));
          Send.message(context,"Login successful",true);
        } else {
          try{
            print("----------------CC----------------------");

            UserModel useer=UserModel(
                Email: widget.phonenumber, Name:"", uid: uid,
                bday: "", education: "", gender: "",
                looking: "", address: "", country: "",
                state:"", pic:"", lastlogin: "",
                online: false, follower: [], following: [],
                stu: [], live: [], hour: 0.0, cl: [], stLive: [],
                facebook: "", youtube: "", instagram: "",
                token: "", amount: 0.0, withdrawal: 0.0, win: 0.0, prizepoints : 0.0, prizewins: 0.0);
            await FirebaseFirestore.instance.collection("users").doc(uid).set(useer.toJson());
            Send.message(context,"New Account Created",true);
            setState(() {
              on=false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfile(isback: false, user: useer,)));
          }catch(e){
            print("--------------------------------------E");

            setState(() {
              on=false;
            });
            Send.message(context,"$e",true);
          }
        }
      } catch (e) {
        setState(() {
          on=false;
        });
        print("E--------------------------------------");

        Send.message(context,"$e",true);
      }
    } catch (e) {
      setState(() {
        on=false;
      });
      print("------------EEEE--------------------------");

      Send.message(context,"$e", false);
    }
  }

  late Timer _timer;

  int _secondsRemaining = 60;

  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer.cancel();
      }
    });
  }
  void _resendOtp() {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phonenumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Handle auto-verification if needed
      },
      verificationFailed: (FirebaseAuthException e) {
        Send.message(context, e.message ?? "Verification failed", false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          widget.verificationId = verificationId;
        });
        Send.message(context, "OTP resent successfully", true);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
    );
    _startTimer();
  }
  OtpFieldControllerV2 otpController = OtpFieldControllerV2();

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.transparent,
       leading: InkWell(
           onTap: (){
             Navigator.pop(context);
           },
           child: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text("Verify OTP",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
              Text("OTP had been sent to ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 17),),
              SizedBox(height: 10,),
              OTPTextFieldV2(
                controller: otpController,
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: w/8,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 15,
                style: TextStyle(fontSize: 18),
                onChanged: (pin) {
                  print("Changed: " + pin);
                  _otpController.text=pin;
                },
                onCompleted: (pin) {
                  print("Completed: " + pin);
                  _otpController.text=pin;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    _canResend
                        ? "Didn't receive the OTP?"
                        : "Resend OTP in $_secondsRemaining seconds",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                  if (_canResend)
                    TextButton(
                      onPressed: _resendOtp,
                      child: const Text("Resend OTP"),
                    ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: Text(textAlign: TextAlign.center,
                  "By Continuing, you Agree that you are atleast 18 years and Accept our Privacy Policy & Terms and Condition and receive Notifications",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.grey),),
              ),
              SizedBox(height: 10),
              on?Center(child: CircularProgressIndicator()):InkWell(
                  onTap: (){
                    _verifyOtp(context);
                  },
                  child: Send.se(w, "Verify")),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
