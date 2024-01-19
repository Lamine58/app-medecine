// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new
import 'package:app_medcine/exam/centre-exam.dart';
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserExam extends StatefulWidget {
  const UserExam({super.key});

  @override
  State<UserExam> createState() => _UserExamState();
}

class _UserExamState extends State<UserExam> {

  String lang = 'Français';
  final TextEditingController weightController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController medicsController = TextEditingController();
  late String originController = 'Origin';
  late String situationController = 'Situation';
  late String activityController = 'Activity';
  final TextEditingController diseasesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool displayPassword = false;
  late bool spinner = false;

  late List <String> origins = [];
  late List <String> situations = [];
  late List <String> activities = [];

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
        origins = translate('origins',lang);
        situations = translate('situations',lang);
        activities = translate('activities',lang);
        originController = origins[0];
        situationController = situations[0];
        activityController = activities[0];
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        toolbarHeight: 40,
        title: Text(translate('personal_data', lang),style: TextStyle(fontSize: 15,color: Colors.white)),
        backgroundColor: primaryColor(),
        elevation: 0,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: weightController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('weight', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_weight', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: sizeController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('size', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_size', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        Container(
                          padding: EdgeInsets.all(15),
                          height: 55,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                              iconSize: 23,
                              value: originController,
                              onChanged: (String? data) {
                                setState(() {
                                  originController = data!;
                                });
                              },
                              items: origins
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: medicsController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('medics', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_medics', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        Container(
                          padding: EdgeInsets.all(15),
                          height: 55,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                              iconSize: 23,
                              value: situationController,
                              onChanged: (String? data) {
                                setState(() {
                                  situationController = data!;
                                });
                              },
                              items: situations
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        paddingTop(15),
                        Container(
                          padding: EdgeInsets.all(15),
                          height: 55,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                              iconSize: 23,
                              value: activityController,
                              onChanged: (String? data) {
                                setState(() {
                                  activityController = data!;
                                });
                              },
                              items: activities
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        paddingTop(15),
                        TextFormField(
                          maxLines: 4,
                          textInputAction: TextInputAction.next,
                          controller: diseasesController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('diseases', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_diseases', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        ElevatedButton(
                          onPressed: spinner==true ? null : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CenterExam(),
                                ),
                              );
                            } 
                          },
                          child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(translate('confirm_data', lang),
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        paddingTop(20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}