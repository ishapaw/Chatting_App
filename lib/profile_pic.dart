import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/profilephoto.png"),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 35,
                width: 35,
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white))),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xffF5F6F9),
                    ),
                  ),
                  onPressed: () {},
                  child: SvgPicture.asset("assets/camera.svg"),
                ),
              ),
            )
          ],
        ));
  }
}
