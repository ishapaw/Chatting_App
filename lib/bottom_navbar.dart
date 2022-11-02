import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'chat/search.dart';
import 'home.dart';

class BNB extends StatefulWidget {
  const BNB({Key? key}) : super(key: key);

  @override
  State<BNB> createState() => _BNBState();
}

class _BNBState extends State<BNB> {
  List pages = [
    HomeScreen(),
    SearchScreen(),
    SearchScreen(),
  ];
  int currentindex = 0;

  void onTap(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentindex],
      bottomNavigationBar: Container(
        color: Color(0xffE1E0EB),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
              backgroundColor: Color(0xffE1E0EB),
              color: Color(0xff131040),
              activeColor: Color(0xffE1E0EB),
              tabBackgroundColor: Color(0xff131040),
              gap: 8,
              onTabChange: onTap,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.search,
                  text: "Search",
                ),
                GButton(
                  icon: Icons.settings,
                  text: "Settings",
                ),
              ]),
        ),
      ),
    );
  }
}
