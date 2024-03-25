// ignore_for_file: non_constant_identifier_names, unused_field

import 'dart:async';
import 'package:app_medcine/dashboard/dashboard-center.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/landing.dart';
import 'package:app_medcine/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin{

  final _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _controller_logo;
  late Animation<double> _animation_logo;

  _start() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString('cutomerData')!=null){
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => Tabs(context,0)));
    }else if(prefs.getString('userData')!=null){
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => const DashboardCenter())); 
    }else{
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => const Landing())); 
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      _start();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller_logo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    var count = 0;

    _animation_logo = Tween<double>(begin: 1, end: 2).animate(_controller_logo)
      ..addStatusListener((status) {
        setState(() {
          count++;
        });

        if(count<7)
        {
          if (status == AnimationStatus.completed) {
            _controller_logo.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _controller_logo.forward();
          }
        }

          
      });

    _controller.forward();
    _controller_logo.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'ANEPAM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Toboggan',
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor()),
        useMaterial3: true,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr'),
      ],
      home:Container(
        // color: primaryColor(),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo_blue(210),
              paddingTop(20),
              SizedBox(
                width: 120,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: 
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        minHeight: 4.5,
                        backgroundColor: const Color(0xff85d7ff),
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor()),
                        value: _animation.value,
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        ),
      )
    );

  }
}

