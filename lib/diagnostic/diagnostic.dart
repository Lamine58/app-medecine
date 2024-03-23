// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';


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
                    question['responses'][index]['checked'] = value;
                  });
                },
              );
            }),
          ),
        ),
      ],
    );

  }

  Widget radioQuestion(Map<String, dynamic> question,index_question) {

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
                          widget.diagnostic['questions'][index_question]['value'] = question['responses'][index]['reponse'];

                          for (int index = index_question+1; index < widget.diagnostic['questions'].length; index++) {
                              widget.diagnostic['questions'][index]['option'] = '';
                              widget.diagnostic['questions'][index]['value'] = '';
                          }

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


  Future<void> _generateAndSharePDF(BuildContext context) async {

    final ByteData data = await rootBundle.load('assets/images/logo-marvel-blue.png');
    final Uint8List bytes = data.buffer.asUint8List();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Image(
                    pw.MemoryImage(bytes),
                    width: 150,
                    height: 150,
                  ),
                ),
                pw.SizedBox(height: 30),
                for (int index = 0; index < widget.diagnostic['questions'].length; index++)
                  (widget.diagnostic['questions'][index]['condition']!='' && widget.diagnostic['questions'][index]['condition_value']!=widget.diagnostic['questions'][int.parse(widget.diagnostic['questions'][index]['condition'])-1]['value']) 
                  ? pw.SizedBox() : pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          widget.diagnostic['questions'][index]['question'],
                          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height:10),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 5),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(widget.diagnostic['questions'][index]['value'])
                            ],
                          ),
                        ),
                      ],
                    ),
                pw.SizedBox(height: 10),
                pw.Text('Conseil',style: pw.TextStyle(decoration: pw.TextDecoration.underline,fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text(analyseValue(total_point,widget.diagnostic['analyses'])  ?? '' ,style: pw.TextStyle(fontSize: 15,fontWeight: pw.FontWeight.bold))
              ],
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/resultat.pdf';
    final File file = File(tempFilePath);
    await file.writeAsBytes(await pdf.save());

    // ignore: deprecated_member_use
    Share.shareFiles([tempFilePath]);
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
    return null;
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
              _generateAndSharePDF(context);
            },
            child: Text(translate('result_diagnostic',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: (widget.diagnostic['questions']==null || widget.diagnostic['questions'].length==0) ? Center(child: Text("Auncune donnée pour l'instant")) : Column(
            children: [
              for (int index = 0; index < widget.diagnostic['questions'].length; index++)
                widget.diagnostic['questions'][index]['type']=='Question à choix unique' ? 
                ( 
                  (widget.diagnostic['questions'][index]['condition']!='' && widget.diagnostic['questions'][index]['condition_value']!=widget.diagnostic['questions'][int.parse(widget.diagnostic['questions'][index]['condition'])-1]['value']) 
                  ? SizedBox() : radioQuestion(widget.diagnostic['questions'][index],index)
                ) :
                checkboxQuestion(widget.diagnostic['questions'][index])
            ],
          ),
        ),
      ),
    );
  }
}
