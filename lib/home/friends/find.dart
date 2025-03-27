import 'dart:typed_data';

import 'package:carousel_slider_plus/carousel_controller.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/profile.dart';
import 'package:ignou_bscg/home/second/history.dart';
import 'package:ignou_bscg/home/second/notifications.dart';
import 'package:ignou_bscg/home/second/second.dart';
import 'package:ignou_bscg/home/second/transaction.dart' as ass;
import 'package:ignou_bscg/home/third/refer.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:ignou_bscg/providers/storage.dart';
import 'package:ignou_bscg/quiz/add/add_quiz.dart';
import 'package:ignou_bscg/quiz/add/add_quiz_id.dart';
import 'package:ignou_bscg/quiz/home/small_card.dart';
import 'package:ignou_bscg/subpages_messages_club/chatpage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Finds extends StatelessWidget {
  Finds({super.key});
TextEditingController _controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Container(
          width : MediaQuery.of(context).size.width  , height : 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade50, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left : 18.0, right : 10),
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,  hintText: "Search Users",
                  border: InputBorder.none, // No border
                  counterText: '',
                ),
              ),
            ),
          ),
        ),
      ),
      body: _controller.text.isEmpty?Center(
        child: Text("Search Friends"),
      ):StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('name',isEqualTo: _controller.text).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No users found with this Name'));
              }
              final users = snapshot.data!.docs.map((doc) {
                return UserModel.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();
              return ListView.builder(
                itemCount: users.length,
                padding: const EdgeInsets.all(2.0),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return InkWell(
                    onTap: (){
                      Navigator.push(
                          context, PageTransition(
                          child: ChatPage(user: user,), type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 300)
                      ));
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        width: w,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.pic),
                          ),
                          title: Text(user.Name),
                          subtitle: Text("From "+user.address),
                          trailing: Text(user.win.toInt().toString()+" Plays",style: TextStyle(fontWeight: FontWeight.w800),),
                        ),
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
}
