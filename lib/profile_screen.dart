import 'package:chatify/chat/helper.dart';
import 'package:chatify/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatify/widgets/reusable_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Color(0xffE1E0EB),
            padding: EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(children: [
                Center(
                  child: Text(
                    'Profile',
                    style: GoogleFonts.firaSans(
                        fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: 300,
                    height: 540,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xff131040),
                          width: 2,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),

                        SizedBox(
                          height: 45,
                        ),
                        // Container(
                        //   height: 55,
                        //   width: 250,
                        //   margin: EdgeInsets.symmetric(horizontal: 10),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.rectangle,
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(10.0),
                        //       ),
                        //       color: Colors.white,
                        //     ),
                        //     child: Center(
                        //       child: Text(e_mai_l!),
                        //     ),
                        //   ),
                        // ),
                        buildTextField(_text, Icons.person),
                        SizedBox(
                          height: 30,
                        ),

                        Container(
                          width: 150,
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                print("Signed Out");
                                HelperFunctions.saveuserLoggedInSharePreference(
                                    false);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()));
                              });
                            },
                            child: Center(
                              child: Text(
                                'Log Out',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.black;
                                  }
                                  return Color(0xff131040);
                                }),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                          ),
                        )
                        // buildTextField("email", Icons.mail),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // buildTextField("Phone", Icons.phone),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // buildTextField("About", Icons.info),
                      ],
                    )),
              ]),
            )));
  }

  Widget buildTextField(String placeholder, IconData icon) {
    return Container(
      height: 55,
      width: 250,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: Color(0xff131040)),
              SizedBox(
                width: 10,
              ),
              Text(placeholder as String)
            ],
          )),
    );
  }
}
// Container(
// padding: EdgeInsets.all(20),
// decoration: BoxDecoration(
// shape: BoxShape.rectangle,
// borderRadius: BorderRadius.all(
// Radius.circular(10.0),
// ),
// color: Color(0xffF5F6F9),
// ),
// child: Row(
// children: [
// SvgPicture.asset(
// "assets/user.svg",
// width: 22,
// color: Color(0xffF3A888),
// ),
