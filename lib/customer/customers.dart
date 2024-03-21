// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, depend_on_referenced_packages
import 'dart:convert';
import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/customer/data.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Customers extends StatefulWidget {
  final context;
  const Customers(this.context,{Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {

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
    
    var response = await api.get('customers?id=$id');

    try{
      if (response['status'] == 'success') {
        setState(() {
          itemList = response['customers'];
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
        item['first_name'].toString().toLowerCase().contains(query) ||
        item['last_name'].toString().toLowerCase().contains(query)
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
          translate('users', lang),
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
                    child : Text(translate('empty_users', lang))
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Data(item)),
                              );
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
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            backgroundImage: avatar(item['avatar']),
                                          ),
                                          paddingLeft(10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${item['first_name']} ${item['last_name']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 15)),
                                              paddingTop(3),
                                              Text('${item['phone']}',textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 11)),
                                              paddingTop(3),
                                              Text(translate('registration', lang)+' : ${formatDate(DateTime.parse(item['created_at']),locale)}',textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  paddingLeft(10),
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