// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:async';
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/landing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    
    if(prefs.getString('user')==null){
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => Landing())); 
    }else{
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => Container()));
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
      duration: Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller_logo = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
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
      home:Container(
        color: primaryColor(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller_logo,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation_logo.value+2,
                    child: Container(
                      width: 45,
                      height: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo-marvel.png'),
                        ),
                      ),
                    ),
                  );
                },
              ),
              paddingTop(10),
              SizedBox(
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: 
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        minHeight: 5,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff85d7ff)),
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

