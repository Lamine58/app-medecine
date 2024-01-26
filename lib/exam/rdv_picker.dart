import "package:flutter/material.dart";
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamDate extends StatefulWidget {

  const ExamDate({super.key});

  @override
  State<ExamDate> createState() => _ExamDateState();
}


class _ExamDateState extends State<ExamDate> {

  String lang = 'Français';
  late bool _datePicker, _timePicker;
  final TextEditingController _datePickerController = TextEditingController();
  final TextEditingController _timePickerController = TextEditingController();
  final GlobalKey<FormState> _formRdvPickerKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
    _datePicker = true;
    _timePicker = false;
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
        title: Text(
          translate('date_picker', lang),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
      ),
      backgroundColor: primaryColor(),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      translate("date_title", lang),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Form(
                    key: _formRdvPickerKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _datePickerController,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            prefix: Icon(
                              Icons.today,
                              size: 25,
                              color: primaryColor(),
                            ),
                            contentPadding: const EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('date_day', lang),
                            labelStyle: const TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('date_day_error', lang);
                            }
                            return null;
                          },

                        ),
                        paddingTop(15),
                        TextFormField(
                          controller: _timePickerController,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            prefix: Icon(
                              Icons.today,
                              size: 25,
                              color: primaryColor(),
                            ),
                            contentPadding: const EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('date_time', lang),
                            labelStyle: const TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('date_time_error', lang);
                            }
                            return null;
                          },

                        ),
                      ],
                    ),
                  ),
                  paddingTop(15),
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      translate('date_confirm', lang),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
  
}