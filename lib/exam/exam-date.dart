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

  late String _dateLabel;

  late DateTime date, time;

  @override
  void initState() {
    super.initState();
    init();
    _datePicker = true;
    _timePicker = false;
    _dateLabel = (lang == 'Français') ?
    DateTime.now().day.toString() + DateTime.now().month.toString() +
    DateTime.now().year.toString()
    :
    DateTime.now().year.toString() + DateTime.now().month.toString() +
    DateTime.now().day.toString();
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
  }

  void _showDateTimePicker(BuildContext context) {
    (_datePicker) ? showDatePicker(
      context: context, 
      fieldLabelText: _dateLabel,
      firstDate: DateTime.now(),
      lastDate: DateTime((DateTime.now().year)+5),
    ) : (_timePicker) ? showTimePicker(
      context: context,
      hourLabelText: "08",
      minuteLabelText: "30",
      initialTime: const TimeOfDay(hour: 08, minute: 30),
    ) : null;
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
                          onTap: () {
                            setState(() {  
                              _datePicker = true;
                              _timePicker = false;
                              _showDateTimePicker(context);
                            });
                          },
                          onChanged: (value) {
                            setState(() {  
                              _datePicker = false;
                              _timePicker = true;
                              _showDateTimePicker(context);
                            });
                          },
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
                          onTap: () {
                            _datePicker = false;
                            _timePicker = true;
                            _showDateTimePicker(context);
                          },
                          onChanged: (value) {
                            _datePicker = false;
                            _timePicker = false; 
                            _showDateTimePicker(context);
                            /* Automatisation d'envoie via une methode asynchrone 
                            qui verifie la disponibilité de la date et de l'heure et affiche le resultat
                            via un modal et reaffiche automatiquement le selectionneur de date ou d'heure 
                            selon les contraintes.
                            Si plus d'heure pour ce jour alors showDatePicker sinon showTimePicker
                            ou laisser la possibilité de valider via le 
                            material button en dessous */
                          },
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            prefix: Icon(
                              Icons.av_timer_outlined,
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