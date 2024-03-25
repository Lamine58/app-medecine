// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/customer/add-customer.dart';
import 'package:app_medcine/customer/customers.dart';
import 'package:app_medcine/exam/user-exams.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:app_medcine/landing.dart';
import 'package:app_medcine/user/user.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardCenter extends StatefulWidget {
  const DashboardCenter({Key? key}) : super(key: key);

  @override
  State<DashboardCenter> createState() => _DashboardCenterState();
}

class _DashboardCenterState extends State<DashboardCenter> {

  String lang = 'Français';
  var last_name = '';
  var base = '';
  var phone = '';
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
    var data = jsonDecode(prefs.getString('userData')!);

    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
    setState(() {
      last_name = data['user']['first_name']+' '+data['user']['last_name'];
      avatar = data['user']['avatar'];
      id = data['user']['id'];
      phone = data['user']['phone'];
    });

  }
  
  networkImage(){
    return Image.network(base+avatar,fit: BoxFit.cover);
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        title: Text('Message',style: TextStyle(fontSize: 20),),
        content: Text(result,style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor(),
        toolbarHeight: 0,
        elevation: 0,
      ),
      backgroundColor: primaryColor(),
      body: Container(
        color: primaryColor(),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 90,
              color: primaryColor(),
            ),
            Positioned(
              top: 90,
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.remove('userData');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Landing()),
                        (routes)=>false
                      );
                    },
                    child: Icon(BootstrapIcons.box_arrow_right,color: Colors.white)
                  ),
                ),
                Expanded(
                  child: SizedBox()
                )
              ],
            ),
            Positioned(
              top: 35,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => User()),
                          );
                        },
                        child: SizedBox(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 65,
                            child: Container(
                              width: 132,
                              height: 132,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              padding: EdgeInsets.all(6),
                              child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                                child: avatar==null
                                ? Image.asset('assets/images/avatar-2.png',fit: BoxFit.cover)
                                : networkImage()
                              ),
                            )
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.sizeOf(context).height,
              padding: EdgeInsets.only(top: 165),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15,right: 15),
                      child: Center(child: Text(translate('welcome_dash', lang)+' $last_name')),
                    ),
                    paddingTop(10),
                    Padding(
                      padding: const EdgeInsets.only(left:15,right: 15),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: primaryColor(),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(translate('title_center', lang),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100,fontSize: 15)),
                                        paddingTop(7),
                                        Text(translate('label_text', lang),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100,fontSize: 11.5)),
                                        paddingTop(10),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ), 
                            Image.asset('assets/images/medium-shot-doctor-posing-studio.png'),
                          ],
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:15,right: 15,top: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Customers(context)),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/3268085.webp'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(translate('users',lang),style: TextStyle(fontSize: 11)),
                                            ],
                                          ),
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
                              ),
                              paddingLeft(10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AddCustomer()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/6148916.webp'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(translate('add_patient',lang),style: TextStyle(fontSize: 11)),
                                            ],
                                          ),
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
                              ),
                            ],
                          ),
                          paddingTop(10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => UserExams(context)),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/8724468.webp'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(translate('us_examens',lang),style: TextStyle(fontSize: 11)),
                                            ],
                                          ),
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
                              ),
                              paddingLeft(10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => User()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/4741086.webp'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(translate('profil',lang),style: TextStyle(fontSize: 11)),
                                            ],
                                          ),
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}