import 'package:chatify/chat/conv_screen.dart';
import 'package:chatify/chat/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home.dart';
import '../profile_screen.dart';
import '../signin.dart';
import 'helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethod databaseMethod = DatabaseMethod();
  TextEditingController _searchController = TextEditingController();
  bool haveUserSearched = false;

  String _text = "";

  @override
  void initState() {
    super.initState();

    HelperFunctions.getuserNameSharePreference().then((value) {
      setState(() {
        _text = value.toString();
      });
    });
  }

  QuerySnapshot<dynamic>? searchSnapshot;

  initiateSearch() async {
    if (_searchController.text.isNotEmpty) {
      await databaseMethod
          .getUserByUsername(_searchController.text)
          .then((snapshot) {
        searchSnapshot = snapshot;
        setState(() {
          haveUserSearched = true;
        });
      });
    }
  }

  Widget searchList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: searchSnapshot?.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot?.docs[index].data()["name"],
                  userEmail: searchSnapshot?.docs[index].data()["email"]);
            })
        : Container();
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "username: $userName",
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xff131040),
                  ),
                ),
                Text("email: $userEmail",
                    style: GoogleFonts.firaSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xff131040),
                    )),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 35,
            margin: const EdgeInsets.fromLTRB(20, 10, 5, 10),
            child: ElevatedButton(
              onPressed: () {
                createChatRoomAndConverse(userName);
                print("$userName");
              },
              child: Center(
                child: Text(
                  "Message",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black;
                    }
                    return Color(0xff131040);
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
            ),
          )
        ],
      ),
    );
  }

  createChatRoomAndConverse(String userName) {
    String chatRoomId = getChatRoomId(_text, userName);

    List<String?> users = [_text, userName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId
    };

    databaseMethod.createChatRoom(chatRoomId, chatRoomMap);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(
                  chatRoomId: chatRoomId,
                  userName: userName,
                )));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff131040)),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'CHATIFY',
            style: GoogleFonts.firaSans(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Color(0xff131040),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                color: Color(0xffFFB2A9),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/Group14.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: IconButton(
                  color: Color(0xff131040),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
                  icon: Icon(Icons.person),
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(fontSize: 16, color: Color(0xff131040)),
                ),
              ),
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.settings),
                  color: Color(0xff131040),
                  onPressed: () {},
                ),
                title: Text(
                  "Settings",
                  style: TextStyle(fontSize: 16, color: Color(0xff131040)),
                ),
              ),
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.help),
                  color: Color(0xff131040),
                  onPressed: () {},
                ),
                title: Text(
                  "Help",
                  style: TextStyle(fontSize: 16, color: Color(0xff131040)),
                ),
              ),
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.info),
                  color: Color(0xff131040),
                  onPressed: () {},
                ),
                title: Text(
                  "About us",
                  style: TextStyle(fontSize: 16, color: Color(0xff131040)),
                ),
              ),
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.logout_rounded),
                  color: Color(0xff131040),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      print("Signed Out");
                      HelperFunctions.saveuserLoggedInSharePreference(false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    });
                  },
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 16, color: Color(0xff131040)),
                ),
              ),
            ],
          ),
        ),
        body: Container(
            color: Colors.white,
            child: Column(children: [
              Container(
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
                        controller: _searchController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            hintText: "search username",
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
                        initiateSearch();
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    )
                  ],
                ),
              ),
              searchList(),
            ])));
  }
}
