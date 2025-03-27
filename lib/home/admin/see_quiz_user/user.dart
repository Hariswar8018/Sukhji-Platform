import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/user/plays.dart';
import 'package:ignou_bscg/user/transactions.dart';

class AllUser extends StatelessWidget {
  const AllUser({super.key});

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
        title: Text("Users Authenticated",style: TextStyle(color: Colors.white),),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                return UserModel.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();

              // Display the list of users
              return ListView.builder(
                itemCount: users.length,
                padding: const EdgeInsets.all(3.0),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: w,
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.pic),
                            ),
                            title: Text(user.Name),
                            subtitle: Text(user.Email),
                            trailing: Text("₹"+user.amount.toString(),style: TextStyle(fontWeight: FontWeight.w800),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 18),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Transactions(name: user.Name, id: user.uid,)));
                                    },
                                    child: Icon(Icons.volunteer_activism_sharp,color: Colors.blue,)),
                                InkWell(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Transactions(name: user.Name, id: user.uid,)));
                                    },
                                    child: Text("See Transactions",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.blue),)),
                                Spacer(),
                                InkWell(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Plays(name: user.Name, id: user.uid,)));
                                    },
                                    child: Icon(Icons.person,color: Colors.blue,)),
                                InkWell(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Plays(name: user.Name, id: user.uid,)));
                                    },
                                    child: Text("See Plays",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.blue),)),
                              ],
                            ),
                          ),
                          SizedBox(height: 12,)
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
}

