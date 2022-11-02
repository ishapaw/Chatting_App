import 'package:chatify/chat/helper.dart';
import 'package:chatify/home.dart';
import 'package:chatify/profile_screen.dart';
import 'package:chatify/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bottom_navbar.dart';
import 'chat/database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  DatabaseMethod databaseMethods = new DatabaseMethod();

  TextEditingController _userController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffFFB2A9),
        child: Column(
          children: [
            SizedBox(
              height: 3,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                // Center(
                //   child: Container(
                //     height: 150,
                //     width: 150,
                //     child: Image(
                //       image: AssetImage('assets/Group 14.png'),
                //     ),
                //   ),
                // ),
              ],
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: 460,
                    width: 324,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 26,
                        ),
                        Text(
                          'Sign Up',
                          style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Color(0xff0D0C0C)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        reusableTextField(
                            "username", Icons.person, false, _userController),
                        reusableTextField(
                            " email", Icons.mail, false, _emailController),
                        reusableTextField(" password", Icons.key_sharp, true,
                            _passwordController),
                        SignInSignUpButton(context, false, () {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) {
                            if (value != null) {
                              Map<String, String> userInfoMap = {
                                "name": _userController.text,
                                "email": _emailController.text,
                              };

                              databaseMethods.uploadUserInfo(userInfoMap);
                              HelperFunctions.saveuserEmailSharePreference(
                                  _emailController.text);
                              HelperFunctions.saveuserNameSharePreference(
                                  _userController.text);

                              HelperFunctions.saveuserLoggedInSharePreference(
                                  true);
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BNB()))
                                  .onError((error, stackTrace) {
                                print("Error ${error.toString()}");
                              });
                            }
                          });
                        })
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}