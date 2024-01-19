// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers
import 'package:app_medcine/exam/user-exam.dart';
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Search extends StatefulWidget {
  final item;
  Search(this.item,{Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  var load = false;
  int selectedOption = 0;
  List filteredList = [];
  List itemList = [];
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
          translate('find_center', lang),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top:0,bottom: 30,left: 10,right: 10),
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
                MaterialPageRoute(
                  builder: (context) => UserExam(),
                ),
              );
            },
            child: Text(translate('confirm_center',lang),style: TextStyle(color: Colors.white,fontFamily: 'Toboggan'),textAlign: TextAlign.center)
          ),
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