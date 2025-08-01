import 'package:flutter/material.dart';
import 'package:ignou_bscg/game/pay.dart';
import 'package:ignou_bscg/home/admin/edit_prize.dart';
import 'package:ignou_bscg/model/user_scores.dart';

import '../model/usermodel.dart';
import 'package:uuid/uuid.dart';


class ScoresCards extends StatelessWidget {
  UserModel quiz;bool isadmin;
  String quid;int indexx;bool ludo;
  ScoresCards({super.key,required this.ludo,required this.quiz,required this.isadmin,required this.quid,required this.indexx});
  String convertToShortUUID(String str) {
    var uuid = Uuid();
    print(str);
    // Use UuidNamespaces.url instead of the deprecated constant
    return uuid.v5(Uuid.NAMESPACE_URL, str).substring(0,10); // Shortened
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Container(
      width: w-20,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          indexx==1||indexx==2?Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("# ${indexx+1}",style: TextStyle(fontWeight: FontWeight.w800),),
              CircleAvatar(
                backgroundImage: NetworkImage(quiz.pic),
              ),
            ],
          ):CircleAvatar(
            backgroundImage: NetworkImage(quiz.pic),
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name",style: TextStyle(fontWeight: FontWeight.w800),),
              Text(formatTo17Words(quiz.Name,12),style: TextStyle(fontWeight: FontWeight.w400),),
              isadmin?Text(convertToShortUUID(quiz.uid)):SizedBox(),
            ],
          ),
          SizedBox(width: 15,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Score",style: TextStyle(fontWeight: FontWeight.w800),),
              Text(formatTo17Words(quiz.prizepoints.toStringAsFixed(1),4),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.red),),
            ],
          ),
          Spacer(),
          InkWell(
            onTap: (){
              if(isadmin){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>Pay_Winners(game_id: quid, userid: quiz.uid,
                      username: quiz.Name, ludo: ludo,)));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isadmin?Icon(Icons.edit,color: Colors.green,): Text("Win",style: TextStyle(fontWeight: FontWeight.w800),),
                Text("${quiz.prizewins}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
              ],
            ),
          ),
          SizedBox(width: 10,),
        ],
      ),
    );
  }
  String formatTo17Words(String input,int i) {
    // If the input is shorter than 17 characters, pad it with spaces
    if (input.length < i) {
      return input.padRight(i, ' ');
    }

    // If the input is longer than 17 characters
    // Split the input into words
    List<String> words = input.split(' ');
    String result = '';

    // Build the result word by word until it reaches 17 characters
    for (String word in words) {
      if ((result + word).length <= i) {
        result += (result.isEmpty ? '' : ' ') + word;
      } else {
        break;
      }
    }

    // Pad the result with spaces to ensure it's exactly 17 characters
    return result.padRight(i, ' ');
  }

}
