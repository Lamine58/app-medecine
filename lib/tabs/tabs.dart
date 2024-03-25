// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, prefer_typing_uninitialized_variables, prefer_const_declarations, no_leading_underscores_for_local_identifiers, unused_local_variable
import 'dart:convert';

import 'package:app_medcine/dashboard/dashboard.dart';
import 'package:app_medcine/diagnostic/diagnostics.dart';
import 'package:app_medcine/exam/archives.dart';
import 'package:app_medcine/exam/exam.dart';
import 'package:app_medcine/exam/exams.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tabs extends StatefulWidget {
  final index;
  final context;
  const Tabs(this.context,int this.index,{Key? key}) : super(key: key);
  
  @override
  State<Tabs> createState() => _TabsState(index);
}

class _TabsState extends State<Tabs> {

  _TabsState(this.index);

  final int index;
  String lang = 'Français';


  init() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('cutomerData')!);

    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    };
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext contexts) {

    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: index);
    final iconSize = 30.0;

    List<Widget> _buildScreens(){
      return [
        Dashboard(context),
        Exam(context),
        Archives(null,context),
      ];
    }
    List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                // icon: const Icon(FontAwesomeIcons.houseUser),
                icon: Image.asset('assets/images/9032455.webp'),
                title: translate("home",lang),
                textStyle: TextStyle(fontSize: 10),
                activeColorPrimary: Colors.white,
                inactiveColorPrimary: Color.fromARGB(101, 255, 255, 255),
                iconSize: iconSize,
            ),
            PersistentBottomNavBarItem(
                // icon: const Icon(FluentIcons.calendar_ltr_48_filled),
                icon: Image.asset('assets/images/5307261.webp'),
                title: translate("to_plan",lang),
                textStyle: TextStyle(fontSize: 10),
                activeColorPrimary: Colors.white,
                inactiveColorPrimary: Color.fromARGB(101, 255, 255, 255),
                iconSize: iconSize
            ),
            PersistentBottomNavBarItem(
                // icon: const Icon(FontAwesomeIcons.heartPulse),
                icon: Image.asset('assets/images/7097722.webp'),
                title: translate("archive_exam",lang),
                textStyle: TextStyle(fontSize: 10),
                activeColorPrimary: Colors.white,
                inactiveColorPrimary: Color.fromARGB(101, 255, 255, 255),
                iconSize: iconSize
            ),
        ];
    }

    return Scaffold(
      body:PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: primaryColor(), // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        ),
        navBarStyle: NavBarStyle.style9, // Choose the nav bar style with this property.
    ));
  }
}