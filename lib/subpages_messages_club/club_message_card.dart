
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ignou_bscg/model/message_models.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);
  final Messages message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return user.toString() == widget.message.from ? _blueMessage() : _redMessage();
  }

  Widget _blueMessage() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 12),
              margin: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.message.mes,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  /* Text(
                      MyDate.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style:
                      TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _redMessage() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 1,
          ),
          Flexible(
            child: Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 12),
              margin: EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("You",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color : Colors.grey),),
                  Text(
                    widget.message.mes,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  /*Text(
                      MyDate.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style:
                      TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),*/
                  if (widget.message.read.isNotEmpty)
                    Icon(
                      Icons.done_all,
                      color: Colors.blue,
                      size: 15,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

