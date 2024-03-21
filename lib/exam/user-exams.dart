// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:app_medcine/api/api.dart';
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


class UserExams extends StatefulWidget {
  final context;
  const UserExams(this.context,{Key? key}) : super(key: key);

  @override
  State<UserExams> createState() => _UserExamsState();
}

class _UserExamsState extends State<UserExams> {

  var load = true;
  int selectedOption = 0;
  var filteredList = [];
  var itemList = [];
  // ignore: non_constant_identifier_names
  dynamic next_page_url;
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

  @override
  void initState() {
    super.initState();
    init();
    searchController.addListener(filterItems);
    _scrollController.addListener(_scrollListener);
    base = api.getbaseUpload();
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
                  child: Container(
                    padding: EdgeInsets.only(bottom:20,right: 15,left: 15,top: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: SfPdfViewer.network(
                            base+item['results'][0],
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
                                    _sharePdf(base+item['results'][0],item['type_exam']['name']+' - '+item['code']);
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
                                    _printPdf(base+item['results'][0]);
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
  

  init() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('userData')!);

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
      getData(data['user']['id']);
    });
  }

  getData(id) async {
    
    var response = await api.get('exams?id=$id');

    try{
      if (response['status'] == 'success') {
        setState(() {
          itemList = response['exams'];
          filteredList = itemList;
          load = false;
        });
      }
    }catch(err){}

  }

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = itemList.where((item) =>  
        item['name'].toString().toLowerCase().contains(query) ||
        item['description'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }

  

  avatar(avatar){
    if(avatar==null || avatar=='') {
      return AssetImage('assets/images/avatar-2.png');
    } else {
      return NetworkImage(base+avatar);
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
          translate('us_examens', lang),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
      ),
      backgroundColor: primaryColor(),
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
                    child : Text(translate('empty_exam', lang))
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
                              if(item['results']!=null)
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
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.white,
                                            backgroundImage: avatar(item['customer']['avatar']),
                                          ),
                                          paddingLeft(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${item['type_exam']['name']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 14)),
                                                paddingTop(3),
                                                Text('${item['customer']['first_name']} ${item['customer']['last_name']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 13)),
                                                paddingTop(3),
                                                Text('Code : ${item['code']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 14)),
                                                paddingTop(3),
                                                paddingTop(3),
                                                Text(formatDate(DateTime.parse(item['created_at']),locale),textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                          paddingLeft(10),
                                          item['results']==null ? Text(translate('pending', lang),style: TextStyle(fontSize: 10)) : Text(translate('result', lang),style: TextStyle(fontSize: 10))
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