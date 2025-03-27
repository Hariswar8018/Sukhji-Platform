import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/global/send.dart';
import 'package:ignou_bscg/home/navigation.dart';
import 'package:ignou_bscg/main.dart';
import 'package:ignou_bscg/model/usermodel.dart';
import 'package:ignou_bscg/providers/declare.dart';
import 'package:ignou_bscg/providers/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  UserModel user;
 UserProfile({super.key,this.isback=true,required this.user});
bool isback;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String pic="";
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  void initState(){
    v();
    if(widget.isback){
      hj();
    }

  }
  hj(){
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    username.text=_user!.education;
    name.text=_user!.Name;
    pic=_user.pic;
    age.text=_user.bday;
    address.text=_user.address;
    str=_user.address;
  }
  List<String> districts = [
    "Ajmer",
    "Alwar",
    "Banswara",
    "Baran",
    "Barmer",
    "Bharatpur",
    "Bhilwara",
    "Bikaner",
    "Bundi",
    "Chittorgarh",
    "Churu",
    "Dausa",
    "Dholpur",
    "Dungarpur",
    "Hanumangarh",
    "Jaipur",
    "Jaisalmer",
    "Jalore",
    "Jhalawar",
    "Jhunjhunu",
    "Jodhpur",
    "Karauli",
    "Kota",
    "Nagaur",
    "Pali",
    "Pratapgarh",
    "Rajsamand",
    "Sawai Madhopur",
    "Sikar",
    "Sirohi",
    "Sri Ganganagar",
    "Tonk",
    "Udaipur","Other"
  ];


  v() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.GetUser();
    await _userprovider.getUser;
    print("Got you");
    print(_userprovider.getUser!.uid);
  }
  String str="Ajmer";
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    TextEditingController textEditingController=TextEditingController();
    return WillPopScope(
      onWillPop: () async => widget.isback,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: widget.isback,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: pic.isEmpty?CircleAvatar(
                    radius: 68,
                    backgroundColor: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey.shade300,
                            child: Center(child: Icon(Icons.person,color: Colors.black,size: 60,),),
                          ),
                        ),
                      ),
                    ),
                  ):CircleAvatar(
                    radius: 68,
                    backgroundImage: NetworkImage(pic),
                  ),
                ),
              ),
              Center(
                child: InkWell(
                    onTap: () async {
                      try {
                        setState(() {
                          on=true;
                        });
                        Uint8List? _file = await pickImage(
                            ImageSource.gallery);
                        String photoUrl = await StorageMethods()
                            .uploadImageToStorage('users', _file!, true);
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.user.uid)
                            .update({
                          "pic": photoUrl,
                        });
                        setState(() {
                          pic=photoUrl;
                          on=false;
                        });
                        Send.message(context, "Uploaded", true);
                      }catch(e){
                        setState(() {
                          on=false;
                        });
                        Send.message(context, "$e", false);
                      }
                    },
                    child: Send.see(w-40, "Upload Picture", Icon(Icons.upload,color: Colors.white,))),
              ),
              SizedBox(height: 30,),
              Text("    Enter Username ( max 10 characters )",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 17),),
              r1456(name, w, "Enter Usermame", false),
              SizedBox(height: 15,),
              Text("    Enter Full Name",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 17),),
              r14(username, w, "Full Name", false),
              SizedBox(height: 15,),
              Text("    Enter District",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 17),),
              Padding(
                padding:  EdgeInsets.only(left: 8.0, right: 8.0, top: 5,bottom: 10),
                child: Container(
                  width: w-20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Your District',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      items: districts.map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ))
                          .toList(),
                      value : str,
                      onChanged: (String? value) {
                        if(value==null){
                          return ;
                        }
                        setState(() {
                         str=value;
                         address.text=value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 400,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child:Send.se(w, "Choose District"),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14,),
              Text("    Enter Age ( 18 - 70 )",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 17),),
              r14(age, w, "Enter Age ( 18 - 70 )", true),
              SizedBox(height: 30,),
            ],
          ),
        ),
        persistentFooterButtons: [
          on?Center(child: CircularProgressIndicator()):InkWell(
              onTap: () async {
                setState(() {
                  on=true;
                });
                try{
                  if(username.text.isEmpty){
                    setState(() {
                      on=false;
                    });
                    Send.message(context, "UserName can't be Empty", false);
                    return ;
                  }
                  if(name.text.isEmpty){
                    setState(() {
                      on=false;
                    });
                    Send.message(context, "Name can't be Empty", false);
                    return ;
                  }
                  if(age.text.isEmpty){
                    setState(() {
                      on=false;
                    });
                    Send.message(context, "Age can't be Empty", false);
                    return ;
                  }
                  if(address.text.isEmpty){
                    setState(() {
                      on=false;
                    });
                    Send.message(context, "Address can't be Empty", false);
                    return ;
                  }

                  int i=int.parse(age.text)??0;
                  if(i<18){
                    setState(() {
                      on=false;
                    });
                    Send.message(context, "App is not Available for under 18", false);
                    return ;
                  }
                  await FirebaseFirestore.instance.collection("users").doc(widget.user.uid).update({
                    "address":address.text,
                    "name":name.text,
                    "education":username.text,
                    "bday":age.text,
                    "pic":pic,
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>Navigation()));
                }catch(e){
                  setState(() {
                    on=false;
                  });
                  Send.message(context, "$e", false);
                }
              },
              child: Send.se(w, "Save & Continue")),
        ],
      ),
    );
  }
  bool on=false;
  TextEditingController username=TextEditingController();
  TextEditingController address=TextEditingController();
  TextEditingController age=TextEditingController();
  TextEditingController name=TextEditingController();
  Widget r14(TextEditingController _controller,double w,String str,bool yrrt){
    return  Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          width: w-20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
            child: TextField(
              controller: _controller,
              keyboardType:yrrt?TextInputType.number: TextInputType.name,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w800
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                hintText: str,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget r1456(TextEditingController _controller,double w,String str,bool yrrt){
    return  Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          width: w-20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
            child: TextField(
              controller: _controller,
              keyboardType:yrrt?TextInputType.number: TextInputType.name,
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
                hintText: str,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
 Widget r(TextEditingController _controller,double w,String str){
   return  Center(
     child: Container(
       width: w-10,
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(7),
         border: Border.all(color: Colors.grey.shade300, width: 2),
       ),
       alignment: Alignment.center,
       child: Padding(
         padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
         child: TextField(
           minLines: 3,maxLines: 20,
           controller: _controller,
           keyboardType: TextInputType.name,
           textAlign: TextAlign.left,
           style: TextStyle(
               fontSize: 20,
               color: Colors.black,
               fontWeight: FontWeight.w800
           ),
           decoration: InputDecoration(
             border: InputBorder.none,
             counterText: "",
             hintText: str,
             hintStyle: TextStyle(
               fontSize: 14,
               color: Colors.grey,
             ),
           ),
         ),
       ),
     ),
   );
 }
}
