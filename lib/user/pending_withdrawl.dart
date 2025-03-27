import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/transaction.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class GivenTransactions extends StatelessWidget {
  GivenTransactions({super.key});

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
        title: Text("My Pending Withdrawl",style: TextStyle(color: Colors.white),),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Transactions').where("nameUid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No Transaction found.'));
              }
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
                    child:user.status=="Waiting for Credit"? InkWell(
                      child: Container(
                        width: w,
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: user.pay?Icon(Icons.credit_card,color: Colors.white,):Icon(Icons.account_balance,color: Colors.white,),
                              ),
                              title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w800),),
                              subtitle: Text("Requested Money on "+formatDateTime(user.time),style: TextStyle(fontSize: 9),),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.pic),
                              ),
                              title: Text(user.time2,style: TextStyle(fontWeight: FontWeight.w800),),
                              subtitle: Text(user.transactionId,style: TextStyle(fontSize: 8),),
                              trailing: Text("₹"+user.rupees.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                            ),
                          ],
                        ),
                      ),
                    ):Container(
                      width: w,
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: user.pay?Icon(Icons.credit_card,color: Colors.white,):Icon(Icons.account_balance,color: Colors.white,),
                            ),
                            title: Text(user.status,style: TextStyle(fontWeight: FontWeight.w800),),
                            subtitle: Text("Executed Money on "+formatDateTime(user.time),style: TextStyle(fontSize: 9),),
                          ),
                          ListTile(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Pic(str: user.pic,)),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child:user.pic==""?Icon(Icons.verified_rounded,color: Colors.white,): Icon(Icons.picture_in_picture_outlined,color: Colors.white,),
                            ),
                            title: Text(user.pic==""?"ALREADY PAID":"PAID WITH PHOTO RECEIPT",style: TextStyle(fontWeight: FontWeight.w800),),
                            subtitle: Text(user.transactionId,style: TextStyle(fontSize: 8),),
                            trailing: Text("₹"+user.rupees.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                          ),
                        ],
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
  Future<UserModel?> getUserByUid(String uid) async {
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      return null;
    }
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  TextEditingController _controller=TextEditingController();
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

class Pic extends StatelessWidget {
  String str;
  Pic({super.key,required this.str});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.network(str)),
    );
  }
}
