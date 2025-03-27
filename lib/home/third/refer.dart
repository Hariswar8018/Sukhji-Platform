import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../global/send.dart';

class Refer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Send.bg,
        title: Text("Refer our App",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/Refer-a-friend.gif",width: w,))
          ,Text("Help Us Reach Millions",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Text("Share our App with your Family & Friends",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
          ),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: (){
            Share.share('Hello ! I got New App name *Sukhji Platform* that have many Quizes and you get Chance to Earn Cashback! Quizes are sheduled from 10AM to 10PM. \n\nSo, What are you waiting for?\nDownload now from PlayStore \nhttps://play.google.com/store/apps/details?id=com.starwish.mandla_local');
          },
          child: Center(
            child: Send.se(w, "Share Our App"),
          ),
        )
      ],
    );
  }
}
