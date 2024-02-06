// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/auth/login.dart';
import 'package:app_medcine/customer/customer.dart';
import 'package:app_medcine/exam/exam.dart';
import 'package:app_medcine/exam/exams.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String lang = 'Français';
  var app_name = 'ANEPAM';
  var last_name = '';
  var base = '';
  var id = '';
  var avatar;
  late Api api = Api();

  @override
  void initState() {
    super.initState();
    base = api.getbaseUpload();
    init();
  }

  init() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('cutomerData')!);

    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
    setState(() {
      last_name = data['customer']['last_name'];
      avatar = data['customer']['avatar'];
      id = data['customer']['id'];
    });

    refresh(data,prefs);
  }
  
  refresh(data,prefs) async {
    
    var response = await api.post('user', {"id":data['customer']['id']});

    try{
      if (response['status'] == 'success') {
        data = response;
        await prefs.setString('cutomerData', jsonEncode(response));
        setState(() {
          last_name = data['customer']['last_name'];
          avatar = data['customer']['avatar'];
        });
      }
    }catch(err){}

  }

  networkImage(){
    return NetworkImage(base+avatar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor(),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor(),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left:25,right: 25,top: 20,bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.remove('cutomerData');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (routes)=>false
                          );
                        },
                        child: Icon(BootstrapIcons.box_arrow_right,color: Colors.white)
                      ),
                      Expanded(
                        child: SizedBox()
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Customer(null)),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(73, 255, 255, 255),
                          backgroundImage: 
                          avatar==null
                          ? AssetImage('assets/images/avatar-2.png')
                          : networkImage(),
                          radius: 35,
                        ),
                      )
                    ],
                  ),
                  Text(
                    translate('welcome_dash', lang)+' $last_name',
                    style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.start,
                  ),
                  paddingTop(5),
                  Text(
                    translate('text_dash', lang)+' $app_name',
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                  paddingTop(15),
                ],
              ),
            ),Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25))
                ),
               child: Container(
                 padding: EdgeInsets.only(top: 35),
                 child: SingleChildScrollView(
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Exams('Liste des examens')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/7262998.webp'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                paddingLeft(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(translate('my_exam', lang),style: TextStyle(fontSize: 21)),
                                      Text(translate('my_exam_text', lang),style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right,color:primaryColor())
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7, 
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      paddingTop(15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Exam()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/5307261.webp'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                paddingLeft(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(translate('calendar_exam',lang),style: TextStyle(fontSize: 21)),
                                      Text(translate('calendar_exam_text',lang),style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right,color:primaryColor())
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7, 
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      paddingTop(15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Customer(null)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/5023500.webp'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                paddingLeft(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(translate('file_exam',lang),style: TextStyle(fontSize: 21)),
                                      Text(translate('file_exam_text',lang),style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right,color:primaryColor())
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7, 
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                   ),
                 ),
               ),
              ),
            )
          ],
        ),
      ),
    );
  }
}