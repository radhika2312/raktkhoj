//this file would guide the navigator which page to open
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:raktkhoj/screens/Chat/pick_up/pick_up_layout.dart';
import 'package:raktkhoj/screens/donate_here/donate.dart';
import 'package:raktkhoj/screens/home/home_screen.dart';
import 'package:raktkhoj/screens/additional/additional.dart';
import 'package:raktkhoj/user_oriented_pages/extra.dart';
import 'package:raktkhoj/user_oriented_pages/profile.dart';

import '../colors.dart';
import '../main.dart';


class PageGuide extends StatefulWidget {
//  final int index;
//  PageGuide(this.index);

  @override
  _PageGuideState createState() => _PageGuideState();

}

class _PageGuideState extends State<PageGuide> {
  int index=1;
  String userid;
  final HomePage _listHomePage=HomePage();
  final ExtraPage _listProfilePage=new ExtraPage();
  final Donate _listDonatePage=new Donate();
  final Additional _listInfoPage= new Additional();

  @override
  void initState() {
    super.initState();
  }
 //code to check , which page to be shown as home page
  //deafult page for now is home_page
  Widget _showPage=new HomePage();

  //using switch cases for choosing pages
  Widget _pageChooser(int page)
  {
    switch(page)
    {
      case 1:
        return _listHomePage;
        break;
      case 3:
        return _listProfilePage;
        break;
      case 0:
        return _listInfoPage;
        break;
      case 2:
        return _listDonatePage;
        break;


    }

  }


  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        uid: FirebaseAuth.instance.currentUser.uid,
        scaffold: Scaffold(
        body: Scaffold(
      backgroundColor: Color(0xffffffff),
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        backgroundColor: Colors.white,
        color:kMainRed,
        buttonBackgroundColor: kMainRed,
        height: 50,
        items: <Widget>[
          Icon(Icons.info_outline,size: 22,color: Colors.white,),
          Icon(Icons.add, size: 22,color: Colors.white,),
          Icon(Icons.bloodtype, size: 22,color: Colors.white,),
          Icon(Icons.person, size: 22,color: Colors.white,),
        ],
        onTap: (int tappedIndex) {
          setState(() {
            _showPage=_pageChooser(tappedIndex);
          });

        },
      ),
      body: Container(
        child: _showPage,
      ),
    )
    ));
  }
}

