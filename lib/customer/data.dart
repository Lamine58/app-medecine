// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, depend_on_referenced_packages, sort_child_properties_last
import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/customer/history-data.dart';
import 'package:app_medcine/customer/save-data.dart';
import 'package:app_medcine/customer/update-customer.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Data extends StatefulWidget {
  final customer;
  const Data(this.customer,{Key? key}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {

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
          translate('user', lang),
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
          ),
          Expanded(
            child:Container(
            padding: EdgeInsets.only(top: 15,left: 15,right: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: avatar(widget.customer['avatar']),
                  ),
                ),
                paddingTop(15),
                Center(
                  child: Text('${widget.customer['first_name']} ${widget.customer['last_name']}'),
                ),
                paddingTop(5),
                Center(
                  child: Text(widget.customer['phone']),
                ),
                paddingTop(5),
                Center(
                  child: Text(widget.customer['email'] ?? ''),
                ),
                paddingTop(20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SaveData(widget.customer),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/3626665.webp'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(translate('mesure',lang),style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7, 
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    paddingLeft(10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryData(widget.customer),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/6706803.webp'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(translate('history_mesure',lang),style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7, 
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                paddingTop(15),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateCustomer(widget.customer),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/7017789.webp'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(translate('personal_data',lang),style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7, 
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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