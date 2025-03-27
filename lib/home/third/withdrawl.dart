import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/transaction.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:ignou_bscg/user/payment_withdrawl.dart';
import 'package:ignou_bscg/user/purchase_successful.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class Withdrawl extends StatefulWidget {
  int review;
  Withdrawl({super.key,this.review=0});

  @override
  State<Withdrawl> createState() => _WithdrawlState();
}

class _WithdrawlState extends State<Withdrawl> {
  @override
  void initState() {
    super.initState();
  }
  bool isstarted=false;
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Send.bg,
        automaticallyImplyLeading: true,
        title: Text("Withdrawl Money",style: TextStyle(color: Colors.white),),
      ),

      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹ ${_user!.amount.toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                Text("₹ ${(_user!.amount-we).toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Balance",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                Text("After Withdrawl",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Divider(),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("    Withdrawl Using",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),),
              Spacer()
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 18.0,bottom: 8),
            child: Center(
              child: Container(
                  width: w-23,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Send.bg,
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
          SizedBox(height: 15,),
          Row(
            children: [
              Text("    Withdrawl by ${widget.review==0?giftcardby:"UPI"}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),),
              Spacer()
            ],
          ),  SizedBox(height: 3,),
          widget.review==0?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              as(w,"Amazon","assets/amazon-Pay.png"),
              as(w,"PhonePe","assets/phonepe_llgbwh.webp"),
            ],
          ): Container(
            width: w-40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w800
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                prefixText: "    ",
                hintText: "    Enter UPI ID",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Text("    Withdrawl Amount",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),),
              Spacer()
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0,top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                c("10rupees", 100.0, w),
                c("20rupees", 500.0, w),
                c("50rupees", 1000.0, w),
              ],
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
              onTap: () async {
                if(_user.amount<we){
                  Send.message(context, "You don't have Enough Cashback in your Account", false);
                  return ;
                }
                setState(() {
                  isstarted=true;
                });
                try {
                  String str = DateTime.now().toString();
                  TransactionModel tran = TransactionModel(answer: true,
                    name: "Withdrawl to " +
                        (widget.review == 0 ? "$giftcardby" : "UPI"),
                    method: _controller.text,
                    rupees: we.toDouble(),
                    pay: false,
                    status: "Waiting for Credit",
                    coins: we.toInt(),
                    time: str,
                    time2: _user.Name,
                    nameUid: _user.uid,
                    id: str,
                    pic: _user.pic,
                    transactionId: "SUKHJI" + (DateTime.now().microsecondsSinceEpoch).toString(),
                  );
                  await FirebaseFirestore.instance.collection("users").doc(
                      FirebaseAuth.instance.currentUser!.uid).update({
                    "amount": FieldValue.increment(-we),
                    "withdrawal":FieldValue.increment(we),
                  });
                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("Transaction")
                      .doc(str).set(tran.toJson());
                  await FirebaseFirestore.instance.collection("Transactions")
                      .doc(str).set(tran.toJson());
                  UserProvider _userProvider = Provider.of(
                      context, listen: false);
                  await _userProvider.refreshuser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WithdrawlSuccessful(sum: we,)),
                  );
                }catch(e){
                  Send.message(context, "$e", false);
                }finally{
                  setState(() {
                    isstarted=false;
                  });
                }
              },
              child:isstarted?Center(
                child: CircularProgressIndicator(
                    color: Colors.black,
                    backgroundColor: Send.bg),
              ):
              Center(child: Send.see(w, "Withdrawl ${we.toInt()} to Wallet", Icon(Icons.account_balance_outlined,color: Colors.white,)))),
          Spacer(),
          isstarted?LinearProgressIndicator():SizedBox(),
          SizedBox(height: 10,),
          SizedBox(height: 15,),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
  TextEditingController _controller=TextEditingController();
  String giftcardby="Amazon";
  Widget as(double w,String a,String a2){
    return  InkWell(
      onTap: (){
        setState(() {
          giftcardby=a;
        });
      },
      child: Container(
        width: w/2-20,
        height: 100,
        decoration: BoxDecoration(
         image: DecorationImage(image: AssetImage(a2),fit: BoxFit.cover,opacity: giftcardby==a?1:0.3)
        ),
      ),
    );
  }
  String productid="100rupees";
  double we=100.0;
  String yiop(int y){
    if(y==0){
      return "Gift Card";
    }else if(y==1){
      return "UPI";
    }else {
      return "Invites";
    }
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
        color: yes==widget.review?Colors.white:Send.bg,
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
  Widget c(String pid,double ser,double w){
    return InkWell(
      onTap: () async {
        setState(() {
          productid=pid;
          we=ser;
        });
      },
      child: Container(
        width: w/3-20,
        height: 50,
        decoration: BoxDecoration(
            color:ser==we?Colors.blue.shade100: Colors.black,
            border: Border.all(
                color: ser==we?Colors.blue:Colors.black,
                width:ser==we?1.0: 2.5
            )
        ),
        child: Center(child: Text("₹ ${ser.toInt()}",style: TextStyle(fontWeight: FontWeight.w800,color: ser==we?Colors.black:Colors.white),)),
      ),
    );
  }



}
