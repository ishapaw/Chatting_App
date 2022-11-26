import 'package:chatify/chat/database.dart';
import 'package:chatify/chat/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'helper.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  ConversationScreen({required this.chatRoomId, required this.userName});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethod databaseMethod = DatabaseMethod();
  TextEditingController messageController = TextEditingController();

  String _text = "";
  String? _userName;
  Stream<QuerySnapshot<dynamic>>? chatMessageStream;

  @override
  void initState() {
    databaseMethod.getConversationMessages(widget.chatRoomId)?.then((value) {
      setState(() {
        _userName = widget.userName;
        chatMessageStream = value;
      });
    });

    super.initState();

    HelperFunctions.getuserNameSharePreference().then((value) {
      setState(() {
        _text = value.toString();
      });
    });
  }

  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshot.data as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: (snapshot.data as QuerySnapshot<dynamic>)
                            .docs[index]
                            .data()["message"],
                        sendByMe: _text ==
                            (snapshot.data as QuerySnapshot<dynamic>)
                                .docs[index]
                                .data()["sendBy"]);
                  })
              : Container();
        });
  }

  addMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageController.text,
        "sendBy": _text,
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
      };
      databaseMethod.addConversationMessages(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff131040),
        title: Text(
          "$_userName",
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color(0xffE1E0EB),
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.9),
                        ),
                        controller: messageController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.photo),
                              color: Color(0xff131040),
                            ),
                            hintText: "Message",
                            hintStyle: TextStyle(
                              color: Color(0xff6A5C5C),
                            ),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Color(0xffE1E0EB),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Icon(
                        Icons.send,
                        color: Color(0xff131040),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16))
              : BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
          color: sendByMe ? Color(0xffE1E0EB) : Color(0xff131040),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: sendByMe ? Color(0xff131040) : Color(0xffE1E0EB),
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
