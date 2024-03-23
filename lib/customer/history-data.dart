// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, depend_on_referenced_packages
import 'dart:io';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

class HistoryData extends StatefulWidget {
  final dynamic customer;
  const HistoryData(this.customer,{Key? key}) : super(key: key);

  @override
  State<HistoryData> createState() => _HistoryDataState();
}

class _HistoryDataState extends State<HistoryData> {

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
      getData(widget.customer['id']);
    });
  }

  getData(id) async {
    
    var response = await api.get('measure-customer?id=$id');

    try{
      if (response['status'] == 'success') {
        setState(() {

          itemList = response['measures'];
          filteredList = itemList;
          load = false;

        });
      }
    }catch(err){}

  }

  Future<void> _generateAndSharePDF(item,BuildContext context) async {

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
                    width: 170,
                    height: 170,
                  ),
                ),
                pw.SizedBox(height: 50), 
                pw.Text('${translate('tension', lang)} : ${item['systolic_bp']}',textAlign:pw.TextAlign.start,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 5),
                pw.Text('${translate('tension_art', lang)} : ${item['diastolic_bp']}',textAlign:pw.TextAlign.start,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 5),
                pw.Text('${translate('oxygen', lang)} : ${item['oxygen_saturation']}',textAlign:pw.TextAlign.start,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 5),
                pw.Text('${translate('frequence', lang)} : ${item['heart_rate']}',textAlign:pw.TextAlign.start,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 5),
                pw.Text('${translate('rythme', lang)} : ${item['heart_rhythm']}',textAlign:pw.TextAlign.start,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 5),
                pw.Text('${item['user']['first_name']} ${item['user']['last_name']} - ${item['business']['legal_name']}',textAlign:pw.TextAlign.start,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 5),
                pw.SizedBox(height: 50),
                pw.Text('Date : ${formatDateTime(DateTime.parse(item['time']),locale)}',textAlign:pw.TextAlign.start,style: pw.TextStyle(fontSize: 15)),
              ],
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/releve-de-mesure.pdf';
    final File file = File(tempFilePath);
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([tempFilePath], text: 'Relevé du ${formatDate(DateTime.parse(item['time']),locale)}');
  }
  
  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = itemList.where((item) =>  
        item['heart_rhythm'].toString().toLowerCase().contains(query)
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

  Future<void> _generateAndPrintPDF(item, BuildContext context) async {
  
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
                  width: 170,
                  height: 170,
                ),
              ),
              pw.SizedBox(height: 50),
              pw.Text('${translate('tension', lang)} : ${item['systolic_bp']}', textAlign: pw.TextAlign.start, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 5),
              pw.Text('${translate('tension_art', lang)} : ${item['diastolic_bp']}', textAlign: pw.TextAlign.start, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 5),
              pw.Text('${translate('oxygen', lang)} : ${item['oxygen_saturation']}', textAlign: pw.TextAlign.start, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 5),
              pw.Text('${translate('frequence', lang)} : ${item['heart_rate']}', textAlign: pw.TextAlign.start, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 5),
              pw.Text('${translate('rythme', lang)} : ${item['heart_rhythm']}', textAlign: pw.TextAlign.start, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 5),
              pw.Text('${item['user']['first_name']} ${item['user']['last_name']} - ${item['business']['legal_name']}', textAlign: pw.TextAlign.start, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 5),
              pw.SizedBox(height: 50),
              pw.Text('Date : ${formatDateTime(DateTime.parse(item['time']), locale)}', textAlign: pw.TextAlign.start, style: pw.TextStyle(fontSize: 15)),
            ],
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/releve-de-mesure.pdf';
    final File file = File(tempFilePath);
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(onLayout: (_) => pdf.save());

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
          translate('history_mesure', lang),
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
                    child : Text(translate('empty_mesure', lang))
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
                              // if(item['file']!=null)
                              //   _diplayView(item,context);
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
                                          Text('Date : ${formatDateTime(DateTime.parse(item['time']),locale)}',textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                          Divider(),
                                          Text('${translate('tension', lang)} : ${item['systolic_bp']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 13)),
                                          paddingTop(3),
                                          Text('${translate('tension_art', lang)} : ${item['diastolic_bp']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 13)),
                                          paddingTop(3),
                                          Text('${translate('oxygen', lang)} : ${item['oxygen_saturation']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 13)),
                                          paddingTop(3),
                                          Text('${translate('frequence', lang)} : ${item['heart_rate']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 13)),
                                          paddingTop(3),
                                          Text('${translate('rythme', lang)} : ${item['heart_rhythm']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 13)),
                                          paddingTop(3),
                                          Text('${item['user']['first_name']} ${item['user']['last_name']} - ${item['business']['legal_name']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 13)),
                                          paddingTop(10),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  _generateAndSharePDF(item,context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: primaryColor(),
                                                    borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  width: 100,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Expanded(child: Center(child: Text(translate('share', lang),style: TextStyle(fontSize: 10,color: Colors.white)))),
                                                      Icon(Icons.share,color: Colors.white,size: 14),
                                                      paddingLeft(10),
                                                    ],
                                                  )
                                                ),
                                              ),
                                              paddingLeft(10),
                                              GestureDetector(
                                                onTap: (){
                                                  _generateAndPrintPDF(item,context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: primaryColor(),
                                                    borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  width: 100,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Expanded(child: Center(child: Text(translate('print', lang),style: TextStyle(fontSize: 10,color: Colors.white)))),
                                                      Icon(Icons.print,color: Colors.white,size: 14),
                                                      paddingLeft(10),
                                                    ],
                                                  )
                                                ),
                                              ),
                                            ],
                                          )
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