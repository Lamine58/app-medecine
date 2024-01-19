// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, depend_on_referenced_packages
import 'package:app_medcine/exam/user-exam.dart';
import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';


class Map extends StatefulWidget {
  final item;
  Map(this.item,{Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {

  var load = false;
  int selectedOption = 0;
  List filteredList = [];
  List itemList = [];
  var next_page_url;
  TextEditingController searchController = TextEditingController();
  List options = [];
  bool _isLoading = false;
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
          translate('search_center', lang),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
      ),
      body: 
        Stack(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(5.3703286,-4.0184672),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.sizeOf(context).width, 
              height: 80,
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
          )
        ],
      ),
    );
  }
}