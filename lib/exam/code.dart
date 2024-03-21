// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:app_medcine/tabs/tabs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Code extends StatefulWidget {

  final code;
  const Code(this.code,{super.key});

  @override
  State<Code> createState() => _CodeState();
}

class _CodeState extends State<Code> {

  String lang = 'Français';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
  }

  String format(int number) {
    String numberString = number.toString();
    int length = numberString.length;
    for (int i = length - 3; i > 0; i -= 3) {
      numberString = '${numberString.substring(0, i)} ${numberString.substring(i)}';
    }
    return numberString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        toolbarHeight: 40,
        title: Text(translate('confirmation', lang),style: TextStyle(fontSize: 15,color: Colors.white)),
        backgroundColor: primaryColor(),
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top:0,bottom: 10,left: 10,right: 10),
        child: SizedBox(
          width: double.infinity, 
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: primaryColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Tabs(context,0),
                ),
                (route)=>false
              );
            },
            child: Text(translate('end',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
          ),
        ),
      ),
      body: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(format(int.parse(widget.code)),textAlign: TextAlign.center,style: TextStyle(color: primaryColor(),fontSize: 45)),
                  paddingTop(30),
                  Text(translate("code_message", lang),textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
  
}