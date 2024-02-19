// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/exam/archive.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class Archives extends StatefulWidget {
  final dynamic item;
  const Archives(this.item,{Key? key}) : super(key: key);

  @override
  State<Archives> createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {

  var load = true;
  int selectedOption = 0;
  var filteredList = [];
  var itemList = [];
  var exams = [];
  var exams_id = {};
  // ignore: non_constant_identifier_names
  TextEditingController searchController = TextEditingController();
  List options = [];
  final ScrollController _scrollController = ScrollController();
  late Api api = Api();

  String lang = 'Français';
  String locale = 'fr_FR';
  String base = '';

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
    }
  }

  List<File> additionalImages = [];

  @override
  void initState() {
    super.initState();
    init();
    base = api.getbaseUpload();
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
      getData(data['customer']['id']);
    });
  }

  getData(id) async {
    
    var response = await api.get('archive-customer?id=$id');

    try{
      if (response['status'] == 'success') {
        setState(() {

          itemList = response['archives'];
          filteredList = itemList;

          for(var item in response['other_exam']){
            exams.add(item['name']);
            exams_id[item['name']]=item['id'];
          }
          load = false;

        });
      }
    }catch(err){}

  }

  
  _diplayView(item,context){

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
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate('exam', lang)+' : '+item['other_exam']['name'],textAlign: TextAlign.left,),
                      Text(translate('exam_date', lang)+' : '+formatDate(DateTime.parse(item['date']), locale),textAlign: TextAlign.left,),
                      Text(translate('register_date', lang)+' : '+formatDate(DateTime.parse(item['time']), locale),textAlign: TextAlign.left,),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom:20,right: 15,left: 15,top: 0),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfPdfViewer.network(
                            base+item['file'],
                          )
                        ),
                        paddingTop(20),
                        SizedBox(
                          width: double.infinity, 
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor(),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    _sharePdf(base+item['file'],item['other_exam']['name']+' - '+item['time']);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(translate('share',lang),style: TextStyle(fontSize: 13,color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)),
                                      paddingLeft(5),
                                      Icon(Icons.share,color: Colors.white),
                                    ],
                                  )
                                ),
                              ),
                              paddingLeft(10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor(),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: (){
                                    _printPdf(base+item['file']);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(translate('print',lang),style: TextStyle(fontSize: 13,color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)),
                                      paddingLeft(5),
                                      Icon(Icons.print,color: Colors.white),
                                    ],
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                        paddingTop(10),
                      ],
                    )
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _printPdf(String url) async {

    final String pdfUrl = url;

    final http.Response response = await http.get(Uri.parse(pdfUrl));
    var bytes = response.bodyBytes;

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDir.path}/temp_pdf.pdf';
    File file = File(filePath);
    await file.writeAsBytes(bytes);

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
    );
  }

  _sharePdf(String url,nameFile) async {

    final String pdfUrl = url;

    final http.Response response = await http.get(Uri.parse(pdfUrl));
    var bytes = response.bodyBytes;

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDir.path}/${nameFile}.pdf';
    File file = File(filePath);
    await file.writeAsBytes(bytes);

    await Share.shareFiles([file.path], text: nameFile);

  }
  
  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = itemList.where((item) =>  
        item['type_exam']['name'].toString().toLowerCase().contains(query) ||
        item['code'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }

  String format(number) {
    String numberString = number;
    int length = numberString.length;
    for (int i = length - 3; i > 0; i -= 3) {
      numberString = '${numberString.substring(0, i)} ${numberString.substring(i)}';
    }
    return numberString;
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
          translate('archive_exam', lang),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
      ),
      backgroundColor: primaryColor(),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Archive(exams,exams_id)),
              );
            },
            child: Text(translate('add',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
          ),
        ),
      ),
      body: 
        Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10),
            decoration: BoxDecoration(
              color: primaryColor(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: TextField(
                      style: TextStyle(color: Colors.white), // Couleur du texte
                      controller: searchController,
                        decoration: InputDecoration(
                          hintText: translate('search', lang),
                          labelStyle: TextStyle(color: Colors.white), // Couleur du texte du label
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(color: Color.fromARGB(90, 245, 245, 245),fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Colors.grey[200]?.withOpacity(0.2), // Couleur de fond (sera obscurcie par le dégradé)
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(77, 255, 255, 255),
                            )
                          ),
                          suffixIcon: Icon(BootstrapIcons.search,color: const Color.fromARGB(77, 255, 255, 255),)
                        ),
                    ),
                  ),
                )
              ],
            ),
          ),
          paddingTop(20),
          load==false && filteredList.isEmpty
          ? Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child : Text(translate('empty_archive', lang))
                  ),
                ],
              ),
            ),
          )
          : load
          ? Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator(color: primaryColor())),
                ],
              ),
            ),
          )
          : Expanded(
            child:Container(
            padding: EdgeInsets.only(top: 15,left: 5,right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Container(
                          padding: EdgeInsets.all(7),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              if(item['file']!=null)
                                _diplayView(item,context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 237, 237, 237),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['other_exam']['name'] ?? '',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 15)),
                                          paddingTop(3),
                                          Text(item['description'],textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                          Text(translate('register_date', lang)+' : '+formatDate(DateTime.parse(item['time']),locale),textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}