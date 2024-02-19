// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/dashboard/dashboard.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Archive extends StatefulWidget {
  final exams;
  final exams_id;
  const Archive(this.exams,this.exams_id,{Key? key}) : super(key: key);

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {

  // ignore: non_constant_identifier_names
  TextEditingController searchController = TextEditingController();
  List options = [];
  late Api api = Api();

  String lang = 'Français';
  String locale = 'fr_FR';
  String base = '';
  String other_exam = '';
  String id = '';
  var dateFormat = new MaskTextInputFormatter(
    mask: '##/##/####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );
  late TextEditingController dateController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

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

  Future<void> getAdditionalData() async {

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {

        setState(() {
          additionalImages = [];
        });

        for (PlatformFile file in result.files) {
          if (file.extension == 'pdf' || file.extension == 'doc' || file.extension == 'docx') {
            setState(() {
              additionalImages.add(File(file.path!));
            });
          } else {
            var compressedFile = await compressImage(file.path!, targetSize: 250 * 1024);
            setState(() {
              additionalImages.add(File(compressedFile.path));
            });

          }
        }
      } else {
      }
    } catch (e) {
      debugPrint('Erreur lors de la sélection des fichiers: $e');
    }
  }

  
  init() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('cutomerData')!);

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
    
    setState(() {
      id = data['customer']['id'];
    });

  }


  @override
  void initState() {
    super.initState();
    init();
    base = api.getbaseUpload();
    other_exam = widget.exams[0];
  }

  List<File> additionalImages = [];

  void _addArchive(context) async {
    
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
      
    var file = additionalImages[0];
    var other_exam_id = widget.exams_id[other_exam];

    try {

      var response;

      response = await api.upload('add-archive',file, {
        "customer_id": id,
        "date": dateController.text,
        "description": descriptionController.text,
        "other_exam_id": other_exam_id
      });

      print(response);

      if (response['status'] == 'success') {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
            (routes)=>false
          );
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
          translate('add_archive', lang),
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
              backgroundColor: primaryColor(),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {

              if(additionalImages.isEmpty){
                _showResultDialog('Veuillez sélectionner le fichier', context);
                return;
              }

              if(dateController.text.trim()==''){
                _showResultDialog('Veuillez saisir la date l\'examen', context);
                return;
              }

              if(descriptionController.text.trim()==''){
                _showResultDialog('Veuillez saisir la description', context);
                return;
              }
              
              _addArchive(context);

            },
            child: Row(
              children: [
                Expanded(child: Text(translate('save',lang),style: const TextStyle(fontSize: 13,color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)),
              ],
            )
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.only(left: 15,right: 15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 229, 229, 229)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                              iconSize: 23,
                              value: other_exam,
                              onChanged: (String? data) {
                                setState(() {
                                  other_exam = data!;
                                });
                              },
                              items: widget.exams
                                .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      paddingTop(15),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.only(left: 15,right: 15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 229, 229, 229)
                          ),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              style: TextStyle(fontSize: 12),
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [dateFormat],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                labelText: translate('exam_date', lang),
                                hintText: translate('exam_date_placeholder', lang),
                                labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  )
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  )
                                ),
                              ),
                            ),
                          )
                        ),
                      ),
                      paddingTop(15),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.only(left: 15,right: 15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 229, 229, 229)
                          ),
                          child: SizedBox(
                            child: TextField(
                              maxLength: 10,
                              controller: descriptionController,
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left:10,top: 10,bottom: 10,right: 10),
                                hintText: 'Description',
                                labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  )
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  )
                                ),
                              ),
                            ),
                          )
                        ),
                      ),
                      paddingTop(15),
                      GestureDetector(
                        onTap: getAdditionalData,
                        child: translate('upload', lang),
                      ),
                      paddingTop(15),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: additionalImages.asMap().entries.map((entry) {
                          int index = entry.key;
                          return Stack(
                            children: [
                              extension(entry.value.path)=='.pdf' ?
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/pdf.png'),
                                    ),
                                  )
                                ),
                              )
                              : extension(entry.value.path)=='.doc' || extension(entry.value.path)=='.docx' ?
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/docx.png'),
                                    ),
                                  )
                                ),
                              )
                              : Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: FileImage(entry.value),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}