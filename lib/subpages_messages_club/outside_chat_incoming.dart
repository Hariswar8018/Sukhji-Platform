/*
import 'package:chess/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat_O extends StatelessWidget {
  Chat_O({super.key});

  List<UserModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController() ;
  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Chat with Friends", style: TextStyle(color: Colors.black),)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: Fire.collection('users').orderBy('lastlogin', descending: true).snapshots(),
        builder: ( context,  snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center( child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs ;
              list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 5),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index){
                  return ChatUser(user: list[index],);
                },);
          }
        },
      ),
    );
  }
}
*/
