// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class Exams extends StatefulWidget {
  final item;
  Exams(this.item,{Key? key}) : super(key: key);

  @override
  State<Exams> createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {

  var load = false;
  int selectedOption = 0;
  List filteredList = [
    {
      "name":"Examen 1",
      "amount":"2000 XOF - WAVE CI",
      "date":"03 janvier 2024",
    },
    {
      "name":"Examen 2",
      "amount":"1000 XOF - WAVE CI",
      "date":"03 janvier 2024",
    },
    {
      "name":"Examen 3",
      "amount":"2000 XOF - WAVE CI",
      "date":"03 janvier 2024",
    },
    {
      "name":"Examen 4",
      "amount":"7200 XOF - WAVE CI",
      "date":"03 janvier 2024",
    },
    {
      "name":"Examen 5",
      "amount":"9000 XOF - WAVE CI",
      "date":"03 janvier 2024",
    }
  ];
  List itemList = [
    {
      "name":"Examen 1",
      "amount":"2000 XOF - WAVE CI",
      "date":"03 janvier 2024",
    },
    {
      "name":"Examen 2",
      "amount":"1000 XOF - WAVE CI",
      "date":"03 janvier 2024",
    },
    {
      "name":"Examen 3",
      "amount":"2000 XOF - WAVE CI",
      "date":"03 janvier 2024",
    },
    {
      "name":"Examen 4",
      "amount":"7200 XOF - WAVE CI",
      "date":"03 janvier 2024",
    },
    {
      "name":"Examen 5",
      "amount":"9000 XOF - WAVE CI",
      "date":"03 janvier 2024",
    }
  ];
  var next_page_url;
  TextEditingController searchController = TextEditingController();
  List options = [];
  ScrollController _scrollController = ScrollController();

  String lang = 'Français';

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
    }
  }

  void initState() {
    super.initState();
    init();
    searchController.addListener(filterItems);
    _scrollController.addListener(_scrollListener);
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
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
                        Image.asset('assets/images/print.png'),
                        Expanded(child: SizedBox()),
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
                                  onPressed: (){
                                    Share.shareXFiles([XFile('assets/images/print.jpg')], text: 'Test de partarge');
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
                                    Printing.layoutPdf(
                                      onLayout: (PdfPageFormat format) async {
                                        final pdfDoc = pw.Document();
                                        final image = await imageFromAssetBundle('assets/images/print.jpg');

                                        pdfDoc.addPage(pw.Page(
                                          pageFormat: format,
                                          build: (pw.Context context) {
                                            return pw.Center(
                                              child: pw.Image(image),
                                            );
                                          },
                                        ));

                                        return pdfDoc.save();
                                      },
                                    );
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

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = itemList.where((item) =>  item['name'].toString().toLowerCase().contains(query)).toList();
    });
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
          translate('my_exam', lang),
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
          load==false && filteredList.length==0
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
                                          Text(item['name'] ?? '',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 15)),
                                          paddingTop(3),
                                          Text('${item['amount']}',textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto')),
                                          Text(item['date'] ?? '',textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.chevron_right,color: primaryColor())
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