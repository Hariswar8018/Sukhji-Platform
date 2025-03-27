import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';

import 'otpscreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: w,
            height: h,
            child: Column(
              children: [
                Container(
                  width: w,
                  height: h-180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/im.jpg"))
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Container(
            width: w,
            height: h,
            child: Column(
              children: [
                Spacer(),
                Container(
                  width: w,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 9,),
                      Text("Login or Sign Up",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 21),),
                      SizedBox(height: 15,),
                      Container(
                        width: w-40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                          maxLength: 10,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                              fontWeight: FontWeight.w800
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            prefixText: "    +91   ",
                            prefixStyle: TextStyle(
                              color: Colors.black,
                                fontSize: 20,
                              fontWeight: FontWeight.w800
                            ),
                            hintText: "Enter 10 digits",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length > 10) {
                              _controller.text = value.substring(0, 10);
                              _controller.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _controller.text.length));
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15,),
                      on?CircularProgressIndicator():InkWell(
                          onTap: () async {
                              String phone = _controller.text.trim();
                              setState(() {
                                on=true;
                              });
                              if (phone.isEmpty || phone.length != 10) {
                                Send.message(context, "Phone is not Equals 10 Digit Number", false);
                                setState(() {
                                  on=false;
                                });
                                return;
                              }

                              try {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: "+91$phone",
                                  verificationCompleted: (PhoneAuthCredential credential) {
                                    // This callback is automatically called in some cases for instant verification
                                    // You can sign in the user automatically here if needed
                                    print("Verification Completed");
                                  },
                                  verificationFailed: (FirebaseAuthException e) {
                                    setState(() {
                                      on=false;
                                    });
                                    Send.message(context, "Verification Failed: ${e.message}", false);
                                  },
                                  codeSent: (String verificationId, int? resendToken) {
                                    setState(() {
                                      on=false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtpLoginScreen(verificationId: verificationId, phonenumber: "+91$phone",),
                                      ),
                                    );
                                  },
                                  codeAutoRetrievalTimeout: (String verificationId) {
                                    setState(() {
                                      on=false;
                                    });
                                    print("Code Auto Retrieval Timeout");
                                  },
                                );
                              } catch (e) {
                                setState(() {
                                  on=false;
                                });
                                Send.message(context, "$e", false);
                              }
                          },
                          child: Send.se(w, "Continue")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  bool on=false;
  TextEditingController _controller=TextEditingController();
}
