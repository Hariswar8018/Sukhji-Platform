import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.Email,
    required this.Name,
    required this.uid,
    required this.bday,
    required this.education,
    required this.gender,
    required this.looking,
    required this.address,
    required this.country,
    required this.state,
    required this.pic,
    required this.lastlogin,
    required this.online,
    required this.follower,
    required this.following,
    required this.stu,
    required this.live,
    required this.hour,
    required this.cl,
    required this.stLive,
    required this.facebook,
    required this.youtube,
    required this.instagram,
    required this.token,
    required this.amount,
    required this.withdrawal,
    required this.win,
  });

  late final String token;
  late final String lastlogin;
  late final bool online;
  late final List<dynamic> follower;
  late final List<dynamic> following;
  late final String pic;
  late final String Email;
  late final String Name;
  late final String uid;
  late final String education;
  late final String bday;
  late final String gender;
  late final String looking;
  late final String country;
  late final String state;
  late final String address;
  late final List<dynamic> stu;
  late final List<dynamic> live;
  late final double hour;
  late final List<dynamic> cl;
  late final List<dynamic> stLive;
  late final String facebook;
  late final String youtube;
  late final String instagram;
  late final double amount;
  late final double withdrawal;
  late final double win;

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'] ?? "h";
    lastlogin = json['lastlogin'] ?? "2024-06-01 19:14:41.231388";
    online = json['online'] ?? false;
    country = json['country'] ?? 'IN';
    state = json['state'] ?? 'Odisha';
    address = json['address'] ?? '45+ WT, Kolkata, Odisha';
    pic = json['pic'] ?? "";
    Email = json['email'] ?? 'haiswar@gmail.com';
    Name = json['name'] ?? 'Nijono Yume';
    uid = json['uid'] ?? '';
    education = json['education'] ?? '+2 Science';
    bday = json['bday'] ?? '';
    gender = json['gender'] ?? 'Male';
    looking = json['looking'] ?? 'Long Term Relationship';
    follower = json['Followers'] ?? [];
    following = json['following'] ?? [];
    stu = json['stu'] ?? [];
    live = json['live'] ?? [];
    hour = (json['hour'] ?? 0).toDouble();
    cl = json['cl'] ?? [];
    stLive = json['stLive'] ?? [];
    facebook = json['facebook'] ?? 'https://www.facebook.com/ayusmansamasi';
    youtube = json['youtube'] ?? '';
    instagram = json['instagram'] ?? '';
    amount = (json['amount'] ?? 0.0).toDouble();
    withdrawal = (json['withdrawal'] ?? 0.0).toDouble();
    win = (json['win'] ?? 0.0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Followers'] = follower;
    data['following'] = following;
    data['country'] = country;
    data['state'] = state;
    data['address'] = address;
    data['email'] = Email;
    data['name'] = Name;
    data['uid'] = uid;
    data['education'] = education;
    data['bday'] = bday;
    data['gender'] = gender;
    data['looking'] = looking;
    data['pic'] = pic;
    data['online'] = online;
    data['token'] = token;
    data['last'] = lastlogin;
    data['stu'] = stu;
    data['live'] = live;
    data['hour'] = hour;
    data['cl'] = cl;
    data['stLive'] = stLive;
    data['facebook'] = facebook;
    data['youtube'] = youtube;
    data['instagram'] = instagram;
    data['amount'] = amount;
    data['withdrawal'] = withdrawal;
    data['win'] = win;
    return data;
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel.fromJson(snapshot);
  }
}
