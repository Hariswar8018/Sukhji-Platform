import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/navigation.dart';
import 'package:ignou_bscg/main.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:provider/provider.dart';

class PurchaseSuccessful extends StatelessWidget {
  double sum;
 PurchaseSuccessful({super.key,required this.sum});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Center(child: Image.asset("assets/added_money.jpg",width: w/2,))
            ,Text("Payment Successful",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child:Text("+ ₹${sum.toInt()}",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 35),),
            ),
            Spacer(),
            InkWell(
                onTap: () async {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navigation()));
                },
                child: Send.se(w, "Continue")),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
