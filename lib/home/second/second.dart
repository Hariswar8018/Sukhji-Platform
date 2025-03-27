import 'package:flutter/material.dart';
import 'package:ignou_bscg/home/second/transaction.dart';
import 'package:ignou_bscg/home/third/withdrawl.dart';
import 'package:ignou_bscg/user/pending_withdrawl.dart';
import 'package:ignou_bscg/user/plays.dart';
import 'package:ignou_bscg/user/purchase.dart';
import 'package:ignou_bscg/user/transactions.dart';
import 'package:provider/provider.dart';

import '../../global/send.dart';
import '../../model/usermodel.dart';
import '../../providers/declare.dart';

class Wallet extends StatefulWidget {
   Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
   bool adddeposit=false,addwithdrawl=false;

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Send.bg,
        title: Text("Balance",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("₹ ${_user!.amount.toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 25),),
              Text("Total Balance",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey.shade300
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                ),
                                child: Icon(Icons.account_balance_wallet),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Deposit",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                                  Text("₹ ${_user!.amount.toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Purchase()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 14,right: 14),
                                    child: Text("Recharge",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        InkWell(
                          onTap: (){
                            setState(() {
                              adddeposit=!adddeposit;
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Text("View Important Info",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                              Spacer(),
                              Icon(Icons.keyboard_arrow_down),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                        adddeposit?Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("You could use Coins to take Part in various Quizes runned Daily. It's non Refundable if you use Coins to take Part in Quizes",style: TextStyle(fontSize: 14),),
                        ):SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: Colors.grey.shade300
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                ),
                                child: Icon(Icons.account_balance_wallet),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Cashback / Withdrawl",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                                  Text("₹ ${_user!.amount.toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Withdrawl()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 14,right: 14),
                                    child: Text("Withdraw",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        InkWell(
                          onTap: (){
                            setState(() {
                              addwithdrawl=!addwithdrawl;
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Text("View Important Info",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                              Spacer(),
                              Icon(Icons.keyboard_arrow_down),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                        addwithdrawl?Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text("If you have Earned Cashback, You could Redeem it to Paytm / Amazon Gift Voucers"),
                        ):SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text("Quick Actions",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
              ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Transactions(name: _user.Name, id: _user.uid,)),
                  );
                },
                tileColor: Colors.white,
                leading: Icon(Icons.recent_actors_sharp),
                title: Text("Transactions"),
                subtitle: Text("View All Transactions"),
                trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GivenTransactions()),
                  );
                },
                tileColor: Colors.white,
                leading: Icon(Icons.transfer_within_a_station),
                title: Text("Pending Withdrawl"),
                subtitle: Text("View All Pending/Complete Withdrawl"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Plays(name: _user.Name, id: _user.uid,)),
                  );
                },
                tileColor: Colors.white,
                leading: Icon(Icons.gamepad),
                title: Text("Games Played"),
                subtitle: Text("View All Games Played"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              )
            ],
          ),
        ),
      ),
    );
  }
}
