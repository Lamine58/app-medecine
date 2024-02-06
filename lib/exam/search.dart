// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/customer/customer.dart';
import 'package:app_medcine/exam/doc-exam.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';


class Search extends StatefulWidget {
  final dynamic item;
  const Search(this.item,{Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  var load = true;
  List filteredList = [];
  List itemList = [];
  // ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names
  late dynamic next_page_url;
  TextEditingController searchController = TextEditingController();
  List options = [];
  final ScrollController _scrollController = ScrollController();
  var base;
  var location = '';

  String lang = 'Français';
  late Api api = Api();

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
    }
  }


  @override
  void initState() {
    super.initState();
    init();
    data();
    searchController.addListener(filterItems);
    _scrollController.addListener(_scrollListener);
    base = api.getbaseUpload();
  }

  init() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('cutomerData')!);

    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
    
    setState(() {
      location = data['customer']['location'] ?? '';
    });
  }

  _displayView(item,context){

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height*0.75,
          child: Column(
            children: [
              paddingTop(10),
              Center(
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: primaryColor(),
                    borderRadius: BorderRadius.circular(5)
                  ),
                ),
              ),
              paddingTop(5),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          child:  CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            backgroundImage: logo(item['logo']),
                            radius: 50,
                          )
                        ),
                        paddingTop(10),
                        Text(item['legal_name'] ?? '',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 15)),
                        paddingTop(20),
                        item['type_exams'].length==0
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(translate("empty_exam_center_action", lang),textAlign: TextAlign.center),
                          )
                        : Column(
                            children: [
                              for(var type_exam  in item['type_exams'])
                                Padding(
                                  padding: const EdgeInsets.only(top:2,bottom:2),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Text(type_exam['name'])),
                                          Container(
                                            child: ElevatedButton(
                                              onPressed:(){
                                                if(location.trim()==''){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => Customer(DocExam(type_exam,item))),
                                                  );
                                                }else{
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => DocExam(type_exam,item)),
                                                  );
                                                }
                                              },
                                              child: Text(translate('do_exam', lang)),
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider()
                                    ],
                                  ),
                                )
                            ],
                          ),
                        paddingTop(50),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child:ElevatedButton(
                                  onPressed: () async {
                                    var number = item['phone'];
                                    await FlutterPhoneDirectCaller.callNumber(number);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(91, 0, 166, 255),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                        Expanded(
                                        child: Text(translate('calling',lang),style: TextStyle(color: Color.fromARGB(255, 1, 121, 185),fontFamily: 'Toboggan'),textAlign: TextAlign.center)
                                      ),
                                      Icon(Icons.phone)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            paddingLeft(10),
                            Expanded(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child:ElevatedButton(
                                  onPressed: () async {
                                    await launchUrl(Uri.parse('https://www.google.com/maps?q=${item['location']}'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: primaryColor(),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                        Expanded(
                                        child: Text(translate('geolocalisation',lang),style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontFamily: 'Toboggan'),textAlign: TextAlign.center)
                                      ),
                                      Icon(Icons.location_pin,color:Colors.white)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        paddingTop(10),
                      ]
                    )
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  data() async {
    
    var response = await api.get('exam-center');

    try{
      if (response['status'] == 'success') {
        setState(() {
          itemList = response['centre'];
          filteredList = itemList;
          load = false;
        });
      }
    }catch(err){}

  }

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = itemList.where((item) =>  item['legal_name'].toString().toLowerCase().contains(query)).toList();
    });
  }

  logo(logo){
    if(logo==null || logo=='') {
      return AssetImage('assets/images/hospit.png');
    } else {
      return NetworkImage(base+logo);
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
          translate('find_center', lang),
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
                    child : Text(translate('empty_exam_center', lang))
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
                                _displayView(item,context);
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
                                          Text(item['legal_name'] ?? '',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 15)),
                                          paddingTop(3),
                                          Text('${item['phone']}',textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto')),
                                          Text(item['location'] ?? '',textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  paddingLeft(10),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    backgroundImage: logo(item['logo']),
                                  )
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