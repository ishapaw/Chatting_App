import 'package:chatify/chat/database.dart';
import 'package:chatify/chat/helper.dart';
import 'package:chatify/profile_screen.dart';
import 'package:chatify/reset.dart';
import 'package:chatify/signup.dart';
import 'package:chatify/widgets/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bottom_navbar.dart';
import 'home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  DatabaseMethod databaseMethod = DatabaseMethod();

  signIn() {
    HelperFunctions.saveuserEmailSharePreference(_emailController.text);

    setState(() {
      databaseMethod.getUserByUseremail(_emailController.text).then((val) {
        snapshotUserInfo = val;

        setState(() {
          HelperFunctions.saveuserNameSharePreference(
              snapshotUserInfo?.docs[0].data()["name"]);
        });
      });
    });

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((value) {
      if (value != null) {
        HelperFunctions.saveuserLoggedInSharePreference(true);

        Navigator.push(context, MaterialPageRoute(builder: (context) => BNB()));
      }
    });
  }

  QuerySnapshot<dynamic>? snapshotUserInfo;

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
                    height: 420,
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
                          height: 37,
                        ),
                        Text(
                          'Sign In',
                          style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Color(0xff0D0C0C)),
                        ),
                        SizedBox(
                          height: 26,
                        ),
                        reusableTextField(
                            " email", Icons.mail, false, _emailController),
                        reusableTextField(" password", Icons.key_sharp, true,
                            _passwordController),
                        SignInSignUpButton(context, true, () {
                          signIn();
                        }),
                        signUpOption(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  Column signUpOption() {
    return Column(
      children: [
        forgotPassword(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: Color(0xff484752)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: const Text(
                "SignUp",
                style: TextStyle(
                    color: Color(0xff131040), fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget forgotPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPassword()));
          },
          child: Text("Forgot Password",
              style: TextStyle(color: Color(0xff484752)))),
    );
  }
}
