import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/admin/transaction/see_user.dart';
import 'package:ignou_bscg/model/transaction.dart';
import 'package:ignou_bscg/providers/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AdminTransactions extends StatelessWidget {
  AdminTransactions({super.key});

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
        title: Text("Pending Transactions",style: TextStyle(color: Colors.white),),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Transactions').where("status",isEqualTo: "Waiting for Credit").snapshots(),
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
                    child:user.status=="Waiting for Credit"? Container(
                      width: w,
                      child: Column(
                        children: [
                          ListTile(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    width: w,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Type GiftCard / UPI Invoice',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                                        ),
                                        SizedBox(height: 20),
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
                                            keyboardType: TextInputType.emailAddress,
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
                                              prefixText: "    ",
                                              hintText: "    Enter Gift Coupon/Transaction ID",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        InkWell(
                                            onTap: () async {
                                              String str = DateTime.now().toString();
                                              if(_controller.text.isEmpty){
                                                Navigator.pop(context);
                                                Send.message(context, "Write Something", false);
                                                return;
                                              }
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection("Transactions")
                                                    .doc(user.id).update({
                                                  "status": "Credited / Giftcard Executed",
                                                  "transactionId": _controller.text,
                                                  "time":str,
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection("users").doc(
                                                    user.nameUid).collection(
                                                    "Transaction")
                                                    .doc(user.id).update({
                                                  "status": "Credited / Giftcard Executed",
                                                  "transactionId": _controller.text,
                                                  "time":str,
                                                });
                                                Navigator.pop(context);
                                                as(user.id, user.coins);
                                                Send.message(context, "Done", false);
                                              }catch(e){
                                                Navigator.pop(context);
                                                Send.message(context, "$e", false);
                                              }
                                            },
                                            child: Send.see(w, "Update without Photo Receipt", Icon(Icons.accessibility_new,color: Colors.white,))),
                                        SizedBox(height: 10),
                                        InkWell(
                                            onTap: () async {
                                              String str = DateTime.now().toString();
                                              if(_controller.text.isEmpty){
                                                Navigator.pop(context);
                                                Send.message(context, "Write Something", false);
                                                return;
                                              }
                                              try {
                                                Uint8List? _file = await pickImage(
                                                    ImageSource.gallery);
                                                String photoUrl = await StorageMethods()
                                                    .uploadImageToStorage(
                                                    'users', _file!, true);
                                                await FirebaseFirestore.instance
                                                    .collection("Transactions")
                                                    .doc(user.id).update({
                                                  "status": "Credited / Giftcard Executed",
                                                  "transactionId": _controller.text,
                                                  'pic': photoUrl,
                                                  "time":str,
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection("users").doc(
                                                    user.nameUid).collection(
                                                    "Transaction")
                                                    .doc(user.id).update({
                                                  "status": "Credited / Giftcard Executed",
                                                  "transactionId": _controller.text,
                                                  'pic': photoUrl,
                                                  "time":str,
                                                });
                                                as(user.id, user.coins);
                                                Navigator.pop(context);
                                                Send.message(context, "Done", false);
                                              }catch(e){
                                                Navigator.pop(context);
                                                Send.message(context, "$e", false);
                                              }
                                            },
                                            child: Send.see(w, "Update with Photo Receipt", Icon(Icons.upload,color: Colors.white,))),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: user.pay?Icon(Icons.credit_card,color: Colors.white,):Icon(Icons.account_balance,color: Colors.white,),
                            ),
                            title: Text(user.name+" : "+user.method,style: TextStyle(fontWeight: FontWeight.w800),),
                            subtitle: Text("Requested Money on "+formatDateTime(user.time),style: TextStyle(fontSize: 9),),
                          ),
                          ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SeeUser(find: user.nameUid,)));
                            },
                            leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.pic),
                                ),
                            title: Text(user.time2,style: TextStyle(fontWeight: FontWeight.w800),),
                            subtitle: Text(user.transactionId,style: TextStyle(fontSize: 8),),
                            trailing: Text("₹"+user.rupees.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                          ),
                        ],
                      ),
                    ):Container(
                      width: w,
                      color: Colors.grey.shade50,
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: user.pay?Icon(Icons.credit_card,color: Colors.white,):Icon(Icons.account_balance,color: Colors.white,),
                            ),
                            title: Text(user.status,style: TextStyle(fontWeight: FontWeight.w800),),
                            subtitle: Text("Requested Money on "+formatDateTime(user.time),style: TextStyle(fontSize: 9),),
                          ),
                          ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SeeUser(find: user.nameUid,)));
                            },
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
                  );
                },
              );
          }
        },
      ),
    );
  }
  Future<void> as(String uidd,int amount) async {
    try {
      await FirebaseFirestore.instance
          .collection("users").doc(
          uidd).update({
        "withdrawal": FieldValue.increment(amount),
      });
    }catch(e){

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
