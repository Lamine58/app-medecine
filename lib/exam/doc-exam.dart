// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new, prefer_typing_uninitialized_variables, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_function_literals_in_foreach_calls
import 'dart:convert';
import 'dart:io';
// import 'dart:js_interop';
import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/exam/code.dart';
import 'package:app_medcine/exam/exam-date.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';

class DocExam extends StatefulWidget {

  final type_exam;
  final item;
  const DocExam(this.type_exam,this.item,{super.key});

  @override
  State<DocExam> createState() => _DocExamState();
}

class _DocExamState extends State<DocExam> {

  String lang = 'Français';
  final TextEditingController requestController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool displayPassword = false;
  late bool spinner = false;
  List<File> additionalImages = [];
  final ImagePicker picker = ImagePicker();
  var id;
  late Api api = Api();

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
    
    var data = jsonDecode(prefs.getString('cutomerData')!);
    setState(() {
      id = data['customer']['id'] ?? '';
    });
  }

    
  _addExam(context) async {
    
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

      var data = {
        "type_exam_id":widget.type_exam['id'],
        "order":requestController.text,
        "customer_id":id,
        "business_id":widget.item['id'],
      };

      var files = [];

      var _wait = additionalImages.forEach((item) {
        files.add(item);
      });

      response = await api.uploadMultiFile('add-exam',files,data);

      if (response['status'] == 'success') {

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Code(response['code']),
          ),
        );

      } else {
        Navigator.pop(context);
        _showResultDialog(response['message'],context);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error',context);
    }

  }


  _info(BuildContext context){
      return SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height*0.9,
          padding: EdgeInsets.only(bottom:20,right: 20,left: 20,top: 10),
          child: Column(
            children: [
              paddingTop(5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor(),
                ),
                height: 5,
                width: 100,
              ),
              paddingTop(10),
              Text(translate('info_validate', lang)),
              Expanded(child: SizedBox()),
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
                    _addExam(context);
                  },
                  child: Text(translate('validate',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
                ),
              ),
              paddingTop(10),
            ],
          ),
        ),
      );
  }

  Future<void> getAdditionalData() async {

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        allowMultiple: true,
      );

      if (result != null) {

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

  Future<void> getAdditionalDataFromDocScanner(int index,context) async {
    try {
      File? scannedDoc = (index == 0) ? 
      await DocumentScannerFlutter.launch(context, source: ScannerFileSource.CAMERA, labelsConfig: translate('labels_config', lang))
      :
      await DocumentScannerFlutter.launchForPdf(context, source: ScannerFileSource.CAMERA, labelsConfig: translate('labels_config', lang))
      ;
      setState(() {
        (scannedDoc != null) ? additionalImages.add(scannedDoc) : 
        debugPrint("Aucun document n'a été scanné") ;
      });
    } on PlatformException {
      debugPrint("Echec ou annulation de l'opération de scan de document");
    }
  }

  void removeAdditionalData(int index) {
    setState(() {
      additionalImages.removeAt(index);
    });
  }

  
  void _showResultDialog(String result,context) {
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
        title: Text(translate('data', lang),style: TextStyle(fontSize: 15,color: Colors.white)),
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
                          maxLines: 3,
                          controller: requestController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('query', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300,fontSize: 14),
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
                              return translate('error_query', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        GestureDetector(
                          onTap: getAdditionalData,
                          child: translate('upload',lang)
                        ),
                        paddingTop(10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5)
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget> [
                              IconButton(
                                onPressed: () {
                                  getAdditionalDataFromDocScanner(0,context);
                                },
                                icon: Icon(
                                  Icons.add_a_photo_sharp,
                                  size: 36,
                                  color: Color(0xff00a6ff),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  getAdditionalDataFromDocScanner(1,context);
                                },
                                icon: Icon(
                                  Icons.document_scanner_rounded,
                                  size: 36,
                                  color: Color(0xff00a6ff),
                                ),
                              ),
                            ],
                          ),
                        ),
                        paddingTop(15),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: additionalImages.asMap().entries.map((entry) {
                            int index = entry.key;
                            return Stack(
                              children: [
                                extension(entry.value.path)=='.pdf' ?
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/pdf.png'),
                                    ),
                                  )
                                )
                                : extension(entry.value.path)=='.doc' || extension(entry.value.path)=='.docx' ?
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/docx.png'),
                                    ),
                                  )
                                )
                                : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: FileImage(entry.value),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ),
                                Positioned(
                                  top: 3,
                                  right: 3,
                                  child: GestureDetector(
                                    onTap: () => removeAdditionalData(index),
                                    child: Icon(Icons.close, color: Color.fromARGB(255, 0, 0, 0),size: 20),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        paddingTop(20),
                        ElevatedButton(
                          onPressed: spinner==true ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExamDate(widget.type_exam,widget.item),
                              ),
                            ); 
                          },
                          child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(translate('no_document', lang),
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
                        paddingTop(10),
                        ElevatedButton(
                          onPressed: spinner==true ? null : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              
                              if(additionalImages.isEmpty){
                                _showResultDialog(translate('required_file', lang),context);
                                return;
                              }

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                builder: (BuildContext context) {
                                  return _info(context);
                                },
                              );
                            } 
                          },
                          child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(translate('confirm', lang),
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