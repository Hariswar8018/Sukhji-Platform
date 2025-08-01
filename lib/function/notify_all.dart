import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';

import '../model/usermodel.dart';

class NotifyAll{
  static  sendNotifications(String name, String desc) async {
    // Fetch tokens from Firestore where 'arrayField' contains '1257'
    try{
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      List<String> tokens = [];
      usersSnapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>;
        var user = UserModel.fromJson(data); // Assuming UserModel.fromJson correctly initializes from Map
        print(data);
        if (user.token != null) {
          tokens.add(user.token);
        }
      });
      await sendNotificationsCompany(name, desc, tokens);
    }catch(e){
      print(e);
    }
  }

  static Future<void> sendNotificationsCompany(String name, String desc,List tokens) async {
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );
    for(String token in tokens){
      try{
        var result = await server.send(
          FirebaseSend(
            validateOnly: false,
            message: FirebaseMessage(
              notification: FirebaseNotification(
                title: name,
                body: desc,
              ),
              android: FirebaseAndroidConfig(
                ttl: '3s',
                notification: FirebaseAndroidNotification(
                  icon: 'ic_notification',
                  color: '#009999',
                ),
              ),
              token: token,
            ),
          ),
        );
        print(result.toString());
      }catch(e){
        print(e);
      }
    }

  }

  static Future<void> sendNotification(String name, String desc,String tokens) async {
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );
    try{
      var result = await server.send(
        FirebaseSend(
          validateOnly: false,
          message: FirebaseMessage(
            notification: FirebaseNotification(
              title: name,
              body: desc,
            ),
            android: FirebaseAndroidConfig(
              ttl: '3s', // Optional TTL for notification
              /// Add Delay in String. If you want to add 1 minute delay then add it like "60s"
              notification: FirebaseAndroidNotification(
                icon: 'ic_notification', // Optional icon
                color: '#009999', // Optional color
              ),
            ),
            token: tokens, // Send notification to specific user's token
          ),
        ),
      );

      // Print request response
      print(result.toString());
    }catch(e){
      print(e);
    }

  }

  static  sendc(String name, String desc) async {
    // Fetch tokens from Firestore where 'arrayField' contains '1257'
    try{
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .get();

      List<String> tokens = [];

      // Extract tokens from the fetched documents
      // Extract tokens from the fetched documents
      usersSnapshot.docs.forEach((doc) {
        // Explicitly cast doc.data() to Map<String, dynamic>
        var data = doc.data() as Map<String, dynamic>;

        var user = UserModel.fromJson(data); // Assuming UserModel.fromJson correctly initializes from Map
        print(data);
        if (user.token != null) {
          tokens.add(user.token);
        }
      });
      await sendNotificationsCompany(name, desc, tokens);
    }catch(e){
      print(e);
    }
  }


  static Future<void> sendallhradmin(String source, String name, String desc) async {
    try {
      List<String> tokens = [];
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('type', whereIn: ['Director', 'Organisation'])
          .where('source', isEqualTo: source)
          .get();
      usersSnapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>;
        var user = UserModel.fromJson(data);
        if (user.token != null) {
          tokens.add(user.token);
        }
      });

      if (tokens.isNotEmpty) {
        await sendNotificationsCompany(name, desc, tokens);
        print("Notifications sent successfully.");
      } else {
        print("No tokens found for the given source.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  static final serviceAccountFileContent = <String, String>{
    'type': "service_account",
    'project_id':"sukhji-platform",
    'private_key_id': "26f98b6f23ce5a47ca436b1bb9bec9f4901f752c",
    'private_key': "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC6FSNhai2pH44k\nQycpiTIG61JHNzOG7wKJddseDCHzUcCokTfVtdRpHmSOEyldqKjtuP9VVaNh1quk\na85T7sG7S2EmTChSG6B0qYl2VY8WfvZSbteP7LVrxelDkjFoyFMqGhTJYbBck4dA\n9jy3HqSbCwrOBbnPMdlgciBsJwGhVgKHdNTp16TCzY8LjdvE00ZzSiMRBcrI0enm\ndy2lYLHyXsIzCl6Y2YxJ0bVyOLpSYTwGhtPUgHdsr9Xz2dXtCMUTCoSb58fWfJ/2\nqywK3Yk6iCJOWxtT2UX7ljOHUylNUPPMPVDbZEDLD8bdkOpfjIAWdfVikC7+o4+M\nXCSE4aOTAgMBAAECggEABUzz2I2zO5rmrCQY5KcqpyV4jwcaBHvLc99JEhaLYwh5\nofOdBmKVveF763Yimq84Ef7P5dOOLLZ2O4qcnSnIbU2M42U4+CR0UiPALYBAwVsg\nKMyifvrhrMO9oiCdyrEmI/q2i96orO0WOw9TPxjJhzxtyYeX5DiJy3mvcGqTXSVE\ncfvhZaNASDyGBdnCSfPCokgdPYvsNVb1DPpk2In043j7HtmDzUsM1g3mKYSzUnuy\nO5S6eK0hJnf+6IzYDTeW+yY2xwf1JBagY7XpJtPpJl6OxosqSfCVaMvOkyYXF/Sm\nmZr/zXZjwOLqiQT1DNfln1oigj6+J/HpVbxr0rHPgQKBgQDmyX4QKwJJCZopdlmC\na+nbEq/dnh5o8lZrfkFrKCQpeOAd/z84HxcDt4TJcU0jo/vGVEOHU5x3VpekFtKH\nx6QDZgZV02CobFhg7EtM5VJhBu4sE5no9xVltjkXsrU2NB5pxXLshuByJooJJbgb\n0JhDh+PuatWO4O4tvyfXzsU6gQKBgQDOaWDVIUu2h0n84MVBC9ZwGkQsTxz89xLs\ngkuWbww0WsuayVDgqCFdSt5u+YLdk099Pwhk4U1uje04n0j/7XKgEaS6HsAw8CxF\nfDKLyMQjS4Zsd8kyNfmDyvfDl9KY7cMXDZZ6TJSlCAh7pyQPJsPPr8/qQVtDwXTB\nUNCHbuBMEwKBgQDjt2LM3zMVEAVt7dnqB0KrJ6ghmvfUg3FkBSLVcbkktqEk2Arv\n/DVANJ8wCLydcxtlmRU8fPKBCg78GIzI7uLVe6C6pKPV63nUwLKYABolpKnzEbAm\nn04cmw2AZZPKFOkBYpK/8WGbII3I8s/TmiHzWC09vWpU3XoF53yPwvT2gQKBgGoD\nfZR5sWViPwH+f9FUvyJ8mx8W0xCp5bJLiX8OMfqB16j8VOnN8LT1yyC8ThZ3no/5\nW9pUTWzGwFwgk2G/FuxXo39kY9m+wT4+98cLqpFmLPhw3YlIZ4rlKDPxOl0JYPXq\nKKtPwdixM4ou4jpV8qQs7GCoiLNYHRtc4n1s2Q65AoGBAJRKfHDgtg2DGRP7gVph\n0vXcisLUl08Buf1t6w7EJheBcAY4QHg2j7wVPHmfzqV0rBvmT2HktwSCdWcNCTxo\nFqJchpNJPQPlogLIzHcsZbRENjQYbY3ohuVPYMclL+f1FXLuFcZxepNC2gJGxGj/\n7JCI4kIsAoQ56oZPKmFIgi5k\n-----END PRIVATE KEY-----\n",
    'client_email': "firebase-adminsdk-fbsvc@sukhji-platform.iam.gserviceaccount.com",
    'client_id':"115344181625188050752",
    'auth_uri':  "https://accounts.google.com/o/oauth2/auth",
    'token_uri':  "https://oauth2.googleapis.com/token",
    'auth_provider_x509_cert_url':  "https://www.googleapis.com/oauth2/v1/certs",
    'client_x509_cert_url': "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40sukhji-platform.iam.gserviceaccount.com",
  };
}