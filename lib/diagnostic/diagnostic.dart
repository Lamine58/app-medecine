// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diagnostic extends StatefulWidget {
  final diagnostic;

  const Diagnostic(this.diagnostic, {Key? key}) : super(key: key);

  @override
  _DiagnosticState createState() => _DiagnosticState();
}

class _DiagnosticState extends State<Diagnostic> {

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

  String lang = 'Français';
  var total_point = 0;

  checkboxQuestion(question){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        paddingTop(10),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(question['responses'].length, (index) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(question['responses'][index]['reponse']),
                value: question['responses'][index]['checked'],
                onChanged: (value) {
                  setState(() {
                    if(value!){
                      total_point += int.parse(question['responses'][index]['point']);
                    }else{
                      total_point -= int.parse(question['responses'][index]['point']);
                    }
                    question['responses'][index]['checked'] = value!;
                  });
                },
              );
            }),
          ),
        ),
      ],
    );

  }

  Widget radioQuestion(Map<String, dynamic> question) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        paddingTop(10),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(question['responses'].length, (index) {
              return Row(
                  children: [
                    Text(question['responses'][index]['reponse']),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Radio(
                      value: question['responses'][index]['point'],
                      groupValue: question['option'],
                      onChanged: (value) {
                        setState(() {
                          if(question['option']!=''){
                            total_point -= int.parse(question['option']);
                          }
                          total_point += int.parse(value);
                          question['option'] = value;
                        });
                      },
                    ),
                  ],
                );
            }),
          ),
        ),
      ],
    );
  }


  
  _diplayView(context){

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                paddingTop(10),
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: primaryColor(),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(bottom:20,right: 15,left: 15,top: 0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/5087559.webp'),
                          Text('Total des points : $total_point',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                          paddingTop(10),
                          Text('Conseil',style: TextStyle(decoration: TextDecoration.underline,fontSize: 18)),
                          paddingTop(10),
                          Text(analyseValue(total_point,widget.diagnostic['analyses'])  ?? '' ,style: TextStyle(fontSize: 15))
                        ],
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  } 

  analyseValue(total,analyses) {
    for (var analysis in analyses) {
      final sign = analysis['signe'];
      final value = int.tryParse(analysis['value'] ?? '');

      if (sign == "Si supérieur à" && total >= value!) {
        return analysis['analyse'];
      } else if (sign == "Si inférieur à" && total <= value!) {
        return analysis['analyse'];
      } else if (sign == "Si égale à" && total == value!) {
        return analysis['analyse'];
      }
    }

    return null; // Aucune analyse trouvée
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
          widget.diagnostic['name'],
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top:0,bottom: 20,left: 10,right: 10),
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
              _diplayView(context);
            },
            child: Text(translate('result_diagnostic',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for(var item in widget.diagnostic['questions'])
                item['type']=='Question à choix unique' ? radioQuestion(item) : checkboxQuestion(item)
            ],
          ),
        ),
      ),
    );
  }
}
