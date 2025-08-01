import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';

import '../global/send.dart';
import '../model/game.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
class GameInputScreen extends StatefulWidget {
  bool ludo;
  GameInputScreen({super.key,required this.ludo});

  @override
  State<GameInputScreen> createState() => _GameInputScreenState();
}

class _GameInputScreenState extends State<GameInputScreen> {
  final TextEditingController idController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController playersController = TextEditingController();
 // comma-separated
  final TextEditingController gotRewardController = TextEditingController();
 // comma-separated
  final TextEditingController gameTypeController = TextEditingController();

  final TextEditingController startTimeController = TextEditingController();

  final TextEditingController endTimeController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController gameLinkController = TextEditingController();

  final TextEditingController gameLinkPasswordController = TextEditingController();

  final TextEditingController gameLinkIdController = TextEditingController();
  Widget dcc(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: 3,maxLength: 150,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
  Widget dc(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
  Widget nc(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
  Widget ac(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
  final TextEditingController winning = TextEditingController();
  final TextEditingController priced = TextEditingController();
  final TextEditingController spot = TextEditingController();

  final TextEditingController applink = TextEditingController();
  final TextEditingController appname = TextEditingController();
  final TextEditingController resultime = TextEditingController();

  Future<void> saveGameData(BuildContext context,int price, int spots,) async {
    try {
      String id=DateTime.now().microsecondsSinceEpoch.toString();
      final gameModel = GameModel(
        id: id,
        name: nameController.text,
        players: [],
        gotReward: [],
        gameType: gameTypeController.text,
        startTime: startTimeController.text,
        endTime: endTimeController.text,
        description: descriptionController.text,
        gameLink: gameLinkController.text,
        gameLinkPassword: gameLinkPasswordController.text,
        gameLinkId: gameLinkIdController.text,
        price: price,
        spots: spots,
        winning: winning.text,
        marks: 0,
        registered: [],
        appLink: applink.text,
        appDownloadLink: appname.text,
        resultTime: resultime.text,
      );

      print('Game Data Saved: ${gameModel.toJson()}');
      await FirebaseFirestore.instance.collection(widget.ludo?"LUDO":"CARROM").doc(id).set(gameModel.toJson());
      Navigator.pop(context);
      Send.message(context, "Successful !", true);
    }catch(e){
      Send.message(context, "$e", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Enter Game Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dc('Name', nameController),
              nc('Price', priced),
              dc('Winning', winning),
              nc('Spots', spot),
              Row(
                children: [
                  Container(
                    width: w/2,
                    child: ac('Start Time', startTimeController),
                  ),
                  Container(
                    width: w/2-50,
                    child:InkWell(
                      onTap: () async {
                        final result = await showBoardDateTimePicker(
                          context: context,
                          pickerType: DateTimePickerType.datetime,
                        );
                        print(result);
                        startTimeController.text=result.toString();
                      },
                      child: Container(
                        width: w/2-80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Send.bg,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                        child: Center(child: Text("Select",style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: w/2,
                    child:  ac('End Time', endTimeController),
                  ),
                  Container(
                    width: w/2-50,
                    child:InkWell(
                      onTap: () async {
                        final result = await showBoardDateTimePicker(
                          context: context,
                          pickerType: DateTimePickerType.datetime,
                        );
                        print(result);
                        endTimeController.text=result.toString();
                      },
                      child: Container(
                        width: w/2-80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Send.bg,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                        child: Center(child: Text("Select",style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: w/2,
                    child:  ac('Result Time', resultime),
                  ),
                  Container(
                    width: w/2-50,
                    child:InkWell(
                      onTap: () async {
                        final result = await showBoardDateTimePicker(
                          context: context,
                          pickerType: DateTimePickerType.datetime,
                        );
                        print(result);
                        resultime.text=result.toString();
                      },
                      child: Container(
                        width: w/2-80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Send.bg,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                        child: Center(child: Text("Select",style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Icon(Icons.play_circle),
              Text("Host App Details",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w800),),
              gh(w, widget.ludo),
              dc('Game Link', gameLinkController),
              dc('Game Link Password ( Optional )', gameLinkPasswordController),
              dc('ROOM ID ( Optional )', gameLinkIdController),
              SizedBox(height: 10,),
              dc('Game Play Link', applink),
              dc('Google App Name', appname),
              SizedBox(height: 16),
              Icon(Icons.info),
              Text("Other Details",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w800),),
              dcc('Description', descriptionController),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        InkWell(
            onTap:(){
              try {
                int i = int.parse(priced.text);
                int j = int.parse(spot.text);
                saveGameData(context, i, j);
              }catch(e){
                Send.message(context, "$e", false);
              }
            },
            child: Send.se(w, "Announce Game !"))
      ],
    );
  }

  Widget gh(double w,bool thiss)=>Card(
    child: Container(
        width: w-30,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Colors.blue,
                width: 0.3
            ),
            boxShadow: [new BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
            ),]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(!widget.ludo?"assets/carrom.png":"assets/ludo.jpg",width: w/6,),
            SizedBox(width: 15,),
            Text("X",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w800),),
            SizedBox(width: 15,),
            Image.asset("assets/current-google-play-icon.webp",width: w/6,),

            Spacer(),
          ],
        )
    ),
  );
}
