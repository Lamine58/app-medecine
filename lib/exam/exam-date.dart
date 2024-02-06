// ignore_for_file: prefer_const_constructors

import 'package:app_medcine/exam/card.dart';
import "package:flutter/material.dart";
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class ExamDate extends StatefulWidget {
  final type_exam;
  final item;
  const ExamDate(this.type_exam,this.item,{super.key});

  @override
  State<ExamDate> createState() => _ExamDateState();
}


class _ExamDateState extends State<ExamDate> {

  String lang = 'Français';
  String locale = 'fr_FR';

  var _selectedDay = DateTime.now();

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
    init();
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
        if(lang =='Français'){
          locale ='fr_FR';
        }else{
          locale ='en_US';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        leading: InkWell(
          onTap: () { Navigator.pop(context); },
          child: const Icon(
            Icons.arrow_back,
            size: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor(),
        toolbarHeight: 40,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(translate('date_picker', lang),style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),
          ),
          paddingTop(10),
          TableCalendar(
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible : false
            ),
            locale: locale,
            firstDay: DateTime.now(),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardCustomer(widget.type_exam,widget.item,_selectedDay.toString()),
                    ),
                  ); 
                });
              }
            },
          )
        ],
      ),
    );
  }
  
}