// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, depend_on_referenced_packages
import 'package:app_medcine/auth/login.dart';
import 'package:app_medcine/auth/sign-in.dart';
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {

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

  _info(){
      return SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height*0.9,
          padding: EdgeInsets.only(bottom:20,right: 20,left: 20,top: 10),
          child: Column(
            children: [
              paddingTop(5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor(),
                ),
                height: 5,
                width: 100,
              ),
              paddingTop(10),
              Text(translate('info', lang)),
              Expanded(child: SizedBox()),
              SizedBox(
                width: double.infinity, 
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor(),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(translate('done',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
                ),
              ),
              paddingTop(10),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: statusBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top:0,bottom: 30,left: 10,right: 10),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity, 
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(91, 0, 166, 255),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ),
                    );
                  },
                  child: Text(translate('text_sign',lang),style: TextStyle(color: Color.fromARGB(255, 1, 121, 185),fontFamily: 'Toboggan'),textAlign: TextAlign.center)
                ),
              ),
            ),
            paddingLeft(10),
            Expanded(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  child: Text(translate('text_login',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Color(0xffffffff),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                        icon: Icon(Icons.language),
                        iconSize: 23,
                        value: lang,
                        onChanged: (String? newLang) async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            lang = newLang!;
                            prefs.setString('lang',lang);
                          });
                        },
                        items: <String>['Français', 'English']
                          .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Expanded(child: SizedBox()),
                      GestureDetector(
                        child: Icon(Icons.info_outline,color: primaryColor()),
                        onTap: (){
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            builder: (BuildContext context) {
                              return _info();
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                logo_blue(120),
                Stack(
                  children: [
                    Center(child: Image.asset('assets/images/docteur-4.png',width: 300)),
                    Positioned(
                      bottom: 5,
                      child: Container(
                        padding: EdgeInsets.only(left:10,right: 10),
                        width: MediaQuery.sizeOf(context).width,
                        child: Center(child: Text(translate('title',lang),textAlign: TextAlign.center,style: TextStyle(color: Color(0XFF1d86e6),fontFamily: 'Toboggan',fontSize: 25,fontWeight: FontWeight.w700)))
                      )
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left:10,right: 10),
                  child: Text(
                    translate('description',lang),
                    style: TextStyle(color: Color(0XFF000000),fontSize: 15,fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}