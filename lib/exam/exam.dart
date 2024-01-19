// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:app_medcine/exam/search.dart';
import 'package:app_medcine/exam/map.dart';
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exam extends StatefulWidget {
  const Exam({Key? key}) : super(key: key);

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {


  String lang = 'Français';
  var app_name = 'ANEPAM';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor(),
        toolbarHeight: 45,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(translate('new_exam', lang),style: TextStyle(fontSize: 15,color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor(),
        ),
        child: Column(
          children: [
            Expanded(
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
                            MaterialPageRoute(builder: (context) => Search('Search')),
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
                                      image: AssetImage('assets/images/5376625.webp'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                paddingLeft(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(translate('have_address', lang),style: TextStyle(fontSize: 21)),
                                      Text(translate('have_text', lang),style: TextStyle(fontSize: 12)),
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
                      paddingTop(25),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Map('Map')),
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
                                      image: AssetImage('assets/images/4051621.webp'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                paddingLeft(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(translate('search_address',lang),style: TextStyle(fontSize: 21)),
                                      Text(translate('search_text',lang),style: TextStyle(fontSize: 12)),
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