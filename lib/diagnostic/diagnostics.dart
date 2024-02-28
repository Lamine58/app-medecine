// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/diagnostic/diagnostic.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diagnostics extends StatefulWidget {
  const Diagnostics({Key? key}) : super(key: key);

  @override
  State<Diagnostics> createState() => _DiagnosticsState();
}

class _DiagnosticsState extends State<Diagnostics> {

  String lang = 'Français';
  late Api api = Api();
  var data;
  var load = true;

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


    var response = await api.get('diagnostics');

    try{
      if (response['status'] == 'success') {
        setState(() {
          data = response['diagnostics'];
          load = false;
        });
      }
    }catch(err){
      print(err);
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: primaryColor(),
        toolbarHeight: 40,
        elevation: 0,
        title: Text(
          translate('file_diagnostic', lang),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
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
               child:
                  load ? Center(child: CircularProgressIndicator())
                  : !load && data.length==0 ? Text(translate('empty_diagnostic', lang))
                  :  Container(
                   padding: EdgeInsets.only(top: 10),
                   child: SingleChildScrollView(
                     child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for(var item in data)
                          Column(
                            children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Diagnostic(item)),
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
                                                image: AssetImage('assets/images/5087559.webp'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          paddingLeft(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(item['name'],style: TextStyle(fontSize: 21)),
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
                            ],
                          )
                      ],
                     ),
                   ),
                 ),
               ),
            ),
          ],
        ),
      ),
    );
  }
}