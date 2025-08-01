import 'package:flutter/material.dart';

import '../../../home/admin/edit_prize.dart';
import '../../../model/user_scores.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<UserScore> scores;
  final bool isAdmin;
  final String quizId;

  const LeaderboardWidget({
    super.key,
    required this.scores,
    required this.isAdmin,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    final topThree = scores.take(3).toList();
    final rest = scores.length > 3 ? scores.sublist(3) : [];
    double w=MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            color: Color(0xffB815D0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (topThree.length > 1)
                _topUserCircle(context,topThree[1], 2), // left

              if (topThree.isNotEmpty)
                Transform.translate(
                  offset: const Offset(0, -15), // Move upward by 15 pixels
                  child: _topUserCircle(context,topThree[0], 1, isCenter: true), // middle
                ),

              if (topThree.length > 2)
                _topUserCircle(context,topThree[2], 3), // right
            ],
          ),
        ),
        Container(
          width: w,
          height: 15,
          color: Color(0xffb815d0),
          child: Container(
            width: w,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Container(
                  width: 25,
                  child: Center(child: Text("#",style: TextStyle(fontWeight: FontWeight.w900),)),
                ),
                Container(
                  width: w*1/3,
                  child: Text("Name",style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                Container(
                  width: w*1/3-10,
                  child: Text("District",style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                Container(
                  width: w*1/6-10,
                  child: Text("Score",style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                Container(
                  width: w*1/6-10,
                  child: Text("Prize",style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rest.length,
            itemBuilder: (context, index) {
              final user = rest[index];
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: (){
                    if(isAdmin){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Pay_Win(
                          quiz_id: quizId,
                          userid: user.id,
                          username: user.name,
                        ),
                      ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          child: Center(child: Text((index+4).toString(),style: TextStyle(fontWeight: FontWeight.w900),)),
                        ),
                        Container(
                          width: w*1/3,
                          child: Text(user.name),
                        ),
                        Container(
                          width: w*1/3-10,
                          child: Text(user.address),
                        ),
                        Container(
                          width: w*1/6-10,
                          child: Text(user.score.toStringAsFixed(1)),
                        ),
                        Container(
                          width: w*1/6-10,
                          child: Text("₹"+user.prizewin),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.pic),
                ),
                title: Text(user.name),
                subtitle: Text("District: ${user.address}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(user.score.toStringAsFixed(1),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(width: 5),
                    if (isAdmin)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Pay_Win(
                              quiz_id: quizId,
                              userid: user.id,
                              username: user.name,
                            ),
                          ));
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _topUserCircle(BuildContext context,UserScore user, int rank, {bool isCenter = false}) {
    return Stack(
      children: [
        Column(
          children: [
            InkWell(
              onTap: (){
                if(isAdmin){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Pay_Win(
                      quiz_id: quizId,
                      userid: user.id,
                      username: user.name,
                    ),
                  ));
                }
              },
              child: CircleAvatar(
                radius: isCenter ? 36 : 28,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: Image.network(
                    user.pic,
                    fit: BoxFit.cover,
                    width: isCenter ? 72 : 56,
                    height: isCenter ? 72 : 56,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: isCenter ? 36 : 28, color: Colors.grey);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(strokeWidth: 1));
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(user.name,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            Text(user.score.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
            Text("₹ "+user.prizewin,
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w800)),
          ],
        ),
        rank==1?CircleAvatar(
            backgroundColor: Colors.black,radius: 15,
            child: Image.asset(width: 20,"assets/crown-icon-yellow-color-free-png.png",)):
        CircleAvatar(
            backgroundColor: Colors.white,
            radius: 10,
            child: Center(child: Text("$rank", style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w800)))),
      ],
    );
  }
}
