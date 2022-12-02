import 'package:chatify/signin.dart';
import 'package:flutter/material.dart';
// Color(0xff131040)
//Color(0xffE1E0EB)
//Color(0xffFFB2A9)
import '../signin.dart';

class Constants {
  static String myName = "";
}

Container reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  bool isObscurePassword = true;
  return Container(
    padding: EdgeInsets.all(15),
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

Container SignInSignUpButton(
    BuildContext context, bool isSignIn, Function onTap) {
  return Container(
    width: 150,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Center(
        child: Text(
          isSignIn ? 'SIGN IN' : 'SIGN UP',
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
    ),
  );
}

Container Cancel(BuildContext context, bool isSignIn) {
  return Container(
    width: 150,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      },
      child: Center(
        child: Text(
          'Cancel',
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
    ),
  );
}
