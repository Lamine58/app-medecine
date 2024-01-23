// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new
import 'dart:io';
// import 'dart:js_interop';
import 'package:app_medcine/exam/pay-exam.dart';
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';

class DocExam extends StatefulWidget {
  const DocExam({super.key});

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayExam(),
                      ),
                    );
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

  Future<void> getAdditionalDataFromDocScanner(int index) async {
    try {
      // `scannedDoc` will be the PDF file generated from scanner
      // We can use launch instead of launchForPdf to generate an image file from scanner
      // ScannerFileSource.GALLERY instead of ScanFileSource.CAMERA intuitively
      File? scannedDoc = (index == 0) ? 
      await DocumentScannerFlutter.launch(context as BuildContext, source: ScannerFileSource.CAMERA, labelsConfig: const {})
      :
      await DocumentScannerFlutter.launchForPdf(context as BuildContext, source: ScannerFileSource.CAMERA, labelsConfig: const {})
      ;
      setState(() {
        (scannedDoc != null) ? additionalImages.add(scannedDoc) : 
        debugPrint("Aucun document n'a été scanné") ;
      });
    } on PlatformException {
      // 'Failed to get document path or operation cancelled!';
      debugPrint("Echec ou annulation de l'opération de scan de document");
    }
  }

  void removeAdditionalData(int index) {
    setState(() {
      additionalImages.removeAt(index);
    });
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
                                  getAdditionalDataFromDocScanner(0);
                                },
                                icon: Icon(
                                  Icons.add_a_photo_sharp,
                                  size: 36,
                                  color: Color(0xff00a6ff),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  getAdditionalDataFromDocScanner(1);
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
                        paddingTop(0),
                        ElevatedButton(
                          onPressed: spinner==true ? null : () {
                            if (_formKey.currentState?.validate() ?? false) {
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