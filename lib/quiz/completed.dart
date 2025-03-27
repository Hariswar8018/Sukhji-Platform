import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/navigation.dart';
import 'package:ignou_bscg/main.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Center(child: Image.network("https://media.time4learning.com/uploads/improve-test-scrores-featured-img.png",width: w/2,))
            ,Text("Quiz Submitted",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: Text(textAlign: TextAlign.center,"Quiz Submitted, Result will be shared in few minutes",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
            ),
            Spacer(),
            InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Splash()));
                },
                child: Send.se(w, "Continue")),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
