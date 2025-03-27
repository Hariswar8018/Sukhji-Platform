import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';

class Transactions extends StatelessWidget {
  String id;String name;
 Transactions({super.key,required this.name,required this.id});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Send.bg,
        automaticallyImplyLeading: true,
        title: Text("$name Transactions",style: TextStyle(color: Colors.white),),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(id).collection("Transaction").orderBy("id",descending: true).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No users found.'));
              }

              // Parse users from Firestore documents
              final users = snapshot.data!.docs.map((doc) {
                return TransactionModel.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();
              return ListView.builder(
                itemCount: users.length,
                padding: const EdgeInsets.only(bottom: 3.0),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    elevation: 4,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: w,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: user.pay?Icon(Icons.credit_card,color: Colors.white,):Icon(Icons.account_balance,color: Colors.white,),
                        ),
                        title: Text(user.pay?"Debit":"Credit",style: TextStyle(fontWeight: FontWeight.w800),),
                        subtitle: Text(formatDateTime(user.time)),
                        trailing: Text("₹"+user.rupees.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize:19),),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
  String formatDateTime(String dateTimeString) {
    try {
      // Parse the input string into a DateTime object
      final DateTime parsedDate = DateTime.parse(dateTimeString);

      // Format the DateTime object to "DD/MM/YY on HH:MM"
      final String formattedDate = DateFormat('dd/MM/yy').format(parsedDate);
      final String formattedTime = DateFormat('HH:mm').format(parsedDate);

      return '$formattedDate on $formattedTime';
    } catch (e) {
      // Handle parsing errors
      return 'Invalid DateTime format';
    }
  }
}
