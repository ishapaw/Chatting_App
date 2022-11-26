import 'package:chatify/chat/helper.dart';
import 'package:chatify/profile_pic.dart';
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
  String _mail = "";

  @override
  void initState() {
    super.initState();

    HelperFunctions.getuserNameSharePreference().then((value) {
      setState(() {
        _text = value.toString();
      });
    });

    HelperFunctions.getuserEmailSharePreference().then((value) {
      setState(() {
        _mail = value.toString();
      });
    });
  }

  TextEditingController _about = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Color(0xffFFB2A9),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        ProfilePic(),
                        SizedBox(
                          height: 45,
                        ),

                        buildTextField(_text, Icons.person),
                        SizedBox(
                          height: 30,
                        ),
                        buildTextField(_mail, Icons.mail),
                        SizedBox(
                          height: 30,
                        ),
                        _reusableTextField("about", Icons.info, false, _about),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 120,
                          height: 40,
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

                        // buildTextField("About", Icons.info),
                      ],
                    )),
              ]),
            )));
  }

  Container _reusableTextField(String text, IconData icon, bool isPasswordType,
      TextEditingController controller) {
    bool isObscurePassword = true;
    return Container(
      width: 250,
      height: 55,
      child: TextField(
        controller: controller,
        obscureText: isPasswordType ? isObscurePassword : false,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        cursorColor: Colors.black,
        style: TextStyle(
          color: Colors.black.withOpacity(0.9),
        ),
        decoration: InputDecoration(
          // suffixIcon: isPasswordType
          //     ? IconButton(
          //         onPressed: () {
          //           MaterialStateProperty.resolveWith((states) {
          //             if (states.contains(MaterialState.pressed)) {
          //               isObscurePassword = !isObscurePassword;
          //             }
          //           });
          //         },
          //         icon: Icon(Icons.remove_red_eye, color: Colors.grey),
          //       )
          //     : null,
          prefixIcon: Icon(
            icon,
            color: Color(0xff131040),
          ),
          hintText: text,
          hintStyle: TextStyle(
            color: Color(0xff6A5C5C),
          ),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: Color(0xffE1E0EB),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        keyboardType: isPasswordType
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
      ),
    );
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
            color: Color(0xffE1E0EB),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: Color(0xff131040)),
              SizedBox(
                width: 10,
              ),
              Text(
                placeholder as String,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black87),
              )
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
