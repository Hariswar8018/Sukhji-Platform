import 'dart:typed_data';

import 'package:carousel_slider_plus/carousel_controller.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/admin/copy_paste.dart';
import 'package:ignou_bscg/home/admin/see_quiz_user/choose_date.dart';
import 'package:ignou_bscg/home/admin/see_quiz_user/today_tomorrow.dart';
import 'package:ignou_bscg/home/admin/see_quiz_user/user.dart';
import 'package:ignou_bscg/home/admin/transaction/full.dart';
import 'package:ignou_bscg/home/admin/transaction/pending.dart';
import 'package:ignou_bscg/providers/storage.dart';
import 'package:ignou_bscg/quiz/add/add_quiz_id.dart';
import 'package:ignou_bscg/quiz/home/small_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../model/quiz_type.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
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
    countDocumentsInUsers();
    countTodaysDocumentsInQuiz();
    countTomorrowsDocumentsInQuiz();
    countPending();
    counTrans();
    countPendingbyUPI();

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
  Future<void> countDocumentsInUsers() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      final int docCount = querySnapshot.docs.length;
      print('Number of documents in "Users" collection: $docCount');
      setState(() {
        totaluser=docCount;
      });
    } catch (e) {
      print('Error counting documents: $e');
    }
  }
  int totalpendingbyupi=0;
  Future<void> countPendingbyUPI() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Transactions')
          .where("status", isEqualTo: "Waiting for Credit")
          .get();

      double totalAmount = 0.0;

      for (var doc in querySnapshot.docs) {
        final amount = doc['rupees']; // Accessing the amount field
        if (amount is double) {
          totalAmount += amount;
        }
      }

      final int docCount = querySnapshot.docs.length;
      print('Number of documents in "Transactions" collection: $docCount');
      print('Total amount: $totalAmount');

      setState(() {
        totalpendingbyupi = totalAmount.toInt(); // Update the total amount (Add a variable in your state)
      });
    } catch (e) {
      print('Error counting documents or summing amount: $e');
    }
  }

  int totaltrans=0;
  Future<void> counTrans() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Transactions').get();
      final int docCount = querySnapshot.docs.length;
      print('Number of documents in "Users" collection: $docCount');
      setState(() {
        totaltrans=docCount;
      });
    } catch (e) {
      print('Error counting documents: $e');
    }
  }
  int totalpending=0;
  Future<void> countPending() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Transactions').where("status",isEqualTo: "Waiting for Credit").get();
      final int docCount = querySnapshot.docs.length;
      print('Number of documents in "Users" collection: $docCount');
      setState(() {
        totalpending=docCount;
      });
    } catch (e) {
      print('Error counting documents: $e');
    }
  }
  Future<void> countTodaysDocumentsInQuiz() async {
    try {
      // Format today's date as "yyyy-MM-dd"
      final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Quiz')
          .get();
      final int todaysDocCount = querySnapshot.docs
          .where((doc) => doc.id.startsWith(todayDate))
          .length;
      setState(() {
        todaytotal=todaysDocCount;
      });
      print('Number of documents in "Quiz" for today: $todaysDocCount');
    } catch (e) {
      print('Error counting today\'s documents in Quiz: $e');
    }
  }
  Future<void> countTomorrowsDocumentsInQuiz() async {
    try {
      // Format tomorrow's date as "yyyy-MM-dd"
      final String tomorrowDate = DateFormat('yyyy-MM-dd').format(
        DateTime.now().add(Duration(days: 1)),
      );

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Quiz')
          .get();

      final int tomorrowsDocCount = querySnapshot.docs
          .where((doc) => doc.id.startsWith(tomorrowDate))
          .length;
      setState(() {
        tomorrowquiz=tomorrowsDocCount;
      });
      print('Number of documents in "Quiz" for tomorrow\'s date: $tomorrowsDocCount');
    } catch (e) {
      print('Error counting documents for tomorrow in Quiz: $e');
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
  DateTime uno=DateTime.now();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Send.bg,
        automaticallyImplyLeading: false,
        title: Text("Admin Panel",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            images.isEmpty?Center(child: Text("No Image Uploaded")):Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15),
              child: CarouselSlider(
                  controller: _controller,
                  items: images.map((imageUrl) {
                    return Stack(
                      children: [
                        Container(
                          height: w/4+15,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(imageUrl),fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          width: MediaQuery.of(context).size.width-20,
                        ),
                        Positioned(child: IconButton(onPressed:(){
                          deleteImage(imageUrl);
                        }, icon: Icon(Icons.delete,color: Colors.white,)))
                      ],
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
            InkWell(
                onTap: () async {
                  try {
                    Uint8List? _file = await pickImage(ImageSource.gallery);
                    Send.message(context, "Uploading ", true);
                    if (_file == null) return;
                    String photoUrl = await StorageMethods()
                        .uploadImageToStorage('admin', _file, true);
                    setState(() {
                      images=images+[photoUrl];
                    });
                    await FirebaseFirestore.instance.collection('Users')
                        .doc('Admin')
                        .set({
                      "images": images,
                    });
                    Send.message(context, "Done", true);
                  }catch(e){
                    Send.message(context, "$e", false);
                  }
                },
                child: Center(child: Send.see(w, "Upload Banner",Icon(Icons.upload,color: Colors.white,)))),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Today()));
                    },
                    child: sr("Today Quiz",w,Colors.yellow.shade400,todaytotal,12)),
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Tomorrow()));
                    },
                    child: sr("Tomorrow Quiz",w,Colors.blueAccent.shade100,tomorrowquiz,12)),
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllUser()));
                    },
                    child: srr("Total Users",w,Colors.green.shade300,totaluser)),
                            ],
            ),
            SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTransactions()));
                    },
                    child: srr("Pending Payments",w,Colors.red.shade400,totalpending,)),
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTransactions()));
                    },
                    child: srr("INR to Give",w,Colors.purpleAccent.shade100,totalpendingbyupi)),
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllTransactions()));
                    },
                    child: srr("Transactions",w,Colors.orangeAccent,totaltrans)),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 4,right: 15.0),
              child: Row(
                children: [
                  SizedBox(width: 6,),
                  InkWell(
                    onTap: (){
                      DatePickerBdaya.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2022,1,1),
                          maxTime: DateTime(2080, 6, 7),
                          onChanged: (date) {
                            setState(() {
                              uno=date;
                            });
                          }, onConfirm: (date) {
                            setState(() {
                              uno=date;
                            });
                          }, currentTime: DateTime.now(),
                          locale: LocaleType.en);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(child: Icon(Icons.calendar_month,color: Colors.black,),),
                        ),
                      ),
                    ),
                  ), SizedBox(width: 5,),
                  Text("Today's Quiz",style: TextStyle(fontWeight: FontWeight.w600),),
                  Spacer(),
                  SizedBox(width: 7,),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseDate(uno: uno)));
                      },
                      child: Text("See All Quiz",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.blue),)),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseDate(uno: uno)));
                      },
                      child: Icon(Icons.arrow_forward_outlined,color: Colors.blue,)),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            Container(
              width: w,
              height: 550,
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
                      final todayDateString = uno.toString().split(' ')[0]; // Format: YYYY-MM-DD
                      final data = snapshot.data!.docs.where((doc) {
                        final id = doc['id'] ?? '';
                        return id.contains(todayDateString);
                      }).toList();
        
                      if (data.isEmpty) {
                        return Center(child: Text('No data available for today.'));
                      }
        
                      final list = data
                          .map((e) => QuizTypeModel.fromJson(e.data()))
                          .toList();
        
                      return ListView.builder(
                        itemCount: list.length,
                        padding: EdgeInsets.only(top: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser(
                            quiz: list[index],isadmin: true,
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Send.bg,
        onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuizId()));
      },
        child: Icon(Icons.add,color: Colors.white,),),
    );
  }
  int todaytotal=0,tomorrowquiz=0,totaluser=0;
  Widget sr(String str,double w,Color color,int i,int j){
    return Container(
      width:w/3-10 ,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(str,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 10),),
          Text("$i / $j",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 16),),
        ],
      ),
    );
  }
  Widget srr(String str,double w,Color color,int i){
    return Container(
      width:w/3-10 ,
      height: 80,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(str,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 10),),
          Text("$i",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 16),),
        ],
      ),
    );
  }
}
