// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SaveData extends StatefulWidget {
  @override
  final customer;
  SaveData(this.customer);
  _SaveDataState createState() => _SaveDataState();
}

class _SaveDataState extends State<SaveData> {

  String systolicBP = '120';
  String diastolicBP = '80';
  String oxygenSaturation = '95';
  String heartRate = '';
  String heartRhythm = 'Régulier';

  String lang = 'Français';
  late Api api = Api();
  var user;


  init() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
        if(lang =='Français'){
          heartRhythm = 'Régulier';
        }else{
          heartRhythm = 'Régulier';
        }
      });
    }

    setState(() {
      user = jsonDecode(prefs.getString('userData')!);
    });
    
  }
  
  @override
  void initState() {
    super.initState();
    init();
  }


  void _addMeasure(context) async {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(),
            paddingLeft(20),
            Text(translate('wait',lang))
          ],
        ),
      ),
    );
      

    try {

      var response;

      response = await api.post('add-measure',{
        "systolic_bp": systolicBP,
        "diastolic_bp": diastolicBP,
        "oxygen_saturation": oxygenSaturation,
        "heart_rate": heartRate,
        "heart_rhythm": heartRhythm,
        "customer_id": widget.customer['id'],
        "user_id": user['user']['id'],
        "business_id": user['user']['business_id'],
      });

      print(response);

      if (response['status'] == 'success') {
          Navigator.pop(context);
          Navigator.pop(context);
          _showResultDialog(response['message'],context);
      } else {
        Navigator.pop(context);
        _showResultDialog(response['message'],context);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error',context);
    }

  }

  _showResultDialog(String result,context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        title: Text('Réponse',style: TextStyle(fontSize: 20),),
        content: Text(result,style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        toolbarHeight: 40,
        title: Text(translate('mesure', lang),style: TextStyle(fontSize: 15,color: Colors.white)),
        backgroundColor: primaryColor(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: systolicBP,
              onChanged: (newValue) {
                setState(() {
                  systolicBP = newValue!;
                });
              },
              items: List.generate(
                171,
                (index) => DropdownMenuItem<String>(
                  value: (index + 80).toString(),
                  child: Text('${index + 80}'),
                ),
              ),
              decoration: InputDecoration(labelText: translate('tension', lang)),
            ),
            paddingTop(15),
            DropdownButtonFormField<String>(
              value: diastolicBP,
              onChanged: (newValue) {
                setState(() {
                  diastolicBP = newValue!;
                });
              },
              items: List.generate(
                81,
                (index) => DropdownMenuItem<String>(
                  value: (index + 50).toString(),
                  child: Text('${index + 50}'),
                ),
              ),
              decoration: InputDecoration(labelText: translate('tension_art', lang)),
            ),
            paddingTop(15),
            DropdownButtonFormField<String>(
              value: oxygenSaturation,
              onChanged: (newValue) {
                setState(() {
                  oxygenSaturation = newValue!;
                });
              },
              items: List.generate(
                16,
                (index) => DropdownMenuItem<String>(
                  value: (index + 85).toString(),
                  child: Text('${index + 85}'),
                ),
              ),
              decoration: InputDecoration(labelText: translate('oxygen', lang)),
            ),
            paddingTop(15),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  heartRate = value;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: translate('frequence', lang)),
            ),
            paddingTop(15),
            DropdownButtonFormField<String>(
              value: heartRhythm,
              onChanged: (newValue) {
                setState(() {
                  heartRhythm = newValue!;
                });
              },
            items: translate('rythme_label', lang)
              .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
            decoration: InputDecoration(labelText: translate('rythme', lang)),
            ),
            paddingTop(20),
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

                  if (systolicBP.isNotEmpty && diastolicBP.isNotEmpty && oxygenSaturation.isNotEmpty && heartRate.isNotEmpty && heartRhythm.isNotEmpty) {
                    _addMeasure(context);
                  } else {
                    _showResultDialog('Veuillez saisir toutes les valeurs', context);
                  }
                },
                child: Text(translate('save',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
