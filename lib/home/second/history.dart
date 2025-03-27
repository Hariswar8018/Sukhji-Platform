import 'package:flutter/material.dart';

import '../../global/send.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Send.bg,
        title: Text("All Notification",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.network("https://cdni.iconscout.com/illustration/premium/thumb/payment-failed-illustration-download-in-svg-png-gif-file-formats--no-transaction-made-unsuccessful-error-digital-empty-states-pack-business-illustrations-5639820.png",width: w/2,))
          ,Text("No History",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
          Text("We can't find any Quizes",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
        ],
      ),
    );
  }
}
