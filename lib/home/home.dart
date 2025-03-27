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
import 'package:ignou_bscg/home/third/result.dart';
import 'package:ignou_bscg/model/quiz_type.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:ignou_bscg/providers/storage.dart';
import 'package:ignou_bscg/quiz/add/add_quiz.dart';
import 'package:ignou_bscg/quiz/add/add_quiz_id.dart';
import 'package:ignou_bscg/quiz/home/small_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Home2 extends StatefulWidget {
 Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  final List<String> imgList = [
    'https://img.freepik.com/free-vector/quiz-neon-sign_1262-19629.jpg',
    'https://m.media-amazon.com/images/I/61ea5ftJDcL._h1_.png',
    'https://static.vecteezy.com/system/resources/thumbnails/013/799/784/small_2x/earn-money-banner-flying-gold-coin-illustration-vector.jpg',
    'https://static.vecteezy.com/system/resources/thumbnails/021/179/141/small_2x/banknote-silver-coins-and-gold-coins-bounce-concept-banner-design-on-orange-background-vector.jpg',
'https://png.pngtree.com/thumb_back/fh260/back_our/20190621/ourmid/pngtree-financial-management-making-money-cornucopia-poster-banner-image_185679.jpg',
'https://media.licdn.com/dms/image/v2/C4D12AQHEpumsDGLhbw/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1635691150147?e=2147483647&v=beta&t=_ZKDcDTiIjXfsNNYBbvVV_kUOWyNrkcpwROl6b4T1RE',


      ];

  TextEditingController text=TextEditingController();

 List<QuizTypeModel> list = [];

 late Map<String, dynamic> userMap;

 TextEditingController ud = TextEditingController();

 final Fire = FirebaseFirestore.instance;

  final CarouselSliderController _controller = CarouselSliderController();

 late List<String> images = [];
void initState(){
  fetchImages();
}
 Future<void> fetchImages() async {
   try {
     final DocumentSnapshot documentSnapshot =  await FirebaseFirestore.instance.collection('Users')
         .doc('Admin')
         .get();
     if (documentSnapshot.exists) {
       Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
       List<String> fetchedImages = List<String>.from(data['images'] ?? []);
       print('fjkjchjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
       setState(() {
         images = fetchedImages;
       });
     }
   } catch (e) {
     print('Error fetching images: $e');
   }
 }
  Future<void> deleteImage(String imageUrl) async {
    try {
      setState(() {
        images.remove(imageUrl); // Remove from local list
      });
      await FirebaseFirestore.instance.collection('Users')
          .doc('Admin').update({
        'images': images,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image deleted successfully!'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Uint8List? _file;
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(7),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Profile(back: true,)));
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      child: Center(child: Icon(Icons.person,color: Colors.black,),),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Wallet()));
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(child: Icon(Icons.account_balance_wallet,color: Colors.black,),),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Refer()));
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(child: Icon(Icons.share_outlined,color: Colors.black,),),
                ),
              ),
            ),
          ),
          SizedBox(width: 15,),
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Profile(back: true,)));
                    },
                    child: df(w,"assets/account-avatar-multimedia-svgrepo-com.svg", "Account")),
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Refer()));
                    },
                    child: df(w,"assets/share-svgrepo-com.svg", "Share")),
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Result(showback: true)));
                    },
                    child: df(w,"assets/a-plus-result-svgrepo-com.svg", "Result")),
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Wallet()));
                    },
                    child: df(w,"assets/wallet-svgrepo-com.svg", "Wallet")),
              ],
            ),
            SizedBox(height: 10,),
            images.isEmpty?Center(child: Text("No Image Uploaded")):Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15),
              child: CarouselSlider(
                  controller: _controller,
                  items: images.map((imageUrl) {
                    return Container(
                      height: w/4+15,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(imageUrl),fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      width: MediaQuery.of(context).size.width-20,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: w/4+15,
                    aspectRatio: 16/9,
                    viewportFraction: 3,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 400),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  )
              ),
            ),
            SizedBox(height: 20,),
            Text("   Today's Quiz",style: TextStyle(fontWeight: FontWeight.w600),),
            Container(
              width: w,
              height:h-430,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No data available for today.'));
                      }
                      final todayDateString = DateTime.now().toString().split(' ')[0]; // Format: YYYY-MM-DD
                      final data = snapshot.data!.docs.where((doc) {
                        final id = doc['id'] ?? '';
                        return id.contains(todayDateString);
                      }).toList();
                      if (data.isEmpty) {
                        return Center(child: Text('No data available for today.'));
                      }
                      final list = data.map((e) => QuizTypeModel.fromJson(e.data())).toList();
                      return ListView.builder(
                        itemCount: list.length,
                        padding: EdgeInsets.only(top: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if(index==list.length){
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ChatUser(
                                quiz: list[index],isadmin: false,
                              ),
                            );
                          }
                          return ChatUser(
                            quiz: list[index],isadmin: false,
                          );
                        },
                      );
                  }
                },
              ),
            ),
            SizedBox(height: 30,),
          ]
        ),
      ),
    );
  }

  Widget df(double w,String assetName,String str){
    return Container(
      width: w/4-10,
      height: w/4-10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetName,
            height: w/6-30,
            semanticsLabel: 'Dart Logo',
          ),
          SizedBox(height: 4,),
          Text(str,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),)
        ],
      ),
    );
  }
}
