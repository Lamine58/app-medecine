// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, depend_on_referenced_packages
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/customer/customer.dart';
import 'package:app_medcine/exam/doc-exam.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Map extends StatefulWidget {
  final dynamic item;
  const Map(this.item,{Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {

  bool load = false;
  int selectedOption = 0;
  List centre = [];
  late dynamic next_page_url;
  late Api api = Api();
  var base;
  var location = '';

  
  MapController mapController = MapController();
  LocationData? currentLocation;
  List<Marker> markers = [];

  String lang = 'Français';

  data() async {
    
    var response = await api.get('exam-center');

    try{
      if (response['status'] == 'success') {
        setState(() {
          centre = response['centre'];
          centre.forEach((item) {
            setPosition(item['location'],item);
          });
          load = false;
        });
      }
    }catch(err){}

  }
  
  logo(logo){
    if(logo==null || logo=='') {
      return AssetImage('assets/images/hospit.png');
    } else {
      return NetworkImage(base+logo);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    data();
    _getLocation();
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

   Future<void> _getLocation() async {

    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      _locationData = await location.getLocation();
      setState(() {
        currentLocation = _locationData;
        mapController.move(LatLng(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble()), 12.0);
        markers.add(
          Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(
              currentLocation?.latitude ?? 0.0,
              currentLocation?.longitude ?? 0.0,
            ),
            child: Image.asset('assets/images/pin-5228060-4379637.png'),
          )
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }
  
  void setPosition(String query,item) async {


    final url = Uri.parse('https://nominatim.openstreetmap.org/search');
    final response = await http.get(
      url.replace(queryParameters: {
        'q': query,
        'format': 'json',
      }),
    );

    if (response.statusCode == 200) {

      final responseBody = response.body;
      final decodedResponse = responseBody;

      final data = jsonDecode((decodedResponse)) as List<dynamic>;
      final suggestions_data = data.map((item) => item).toList();

      if(suggestions_data.isNotEmpty){

        setState(() {
          markers.add(
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(
                double.parse(suggestions_data[0]['lat']),
                double.parse(suggestions_data[0]['lon']),
              ),
              child: GestureDetector(
                onTap: () async {
                  _displayView(item,context);
                },
                child: Image.asset('assets/images/hospital-building-5682857-4731205.png'),
              ),
            )
          );
        });
      }

    }

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
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(5.3703286,-4.0184672),
                initialZoom: 21,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(
                        currentLocation?.latitude ?? 0.0,
                        currentLocation?.longitude ?? 0.0,
                      ),
                      radius: 170.0, // Set the radius of the circle
                      color: primaryColor().withOpacity(0.25), // Set the color of the circle
                      borderColor: primaryColor(), // Set the border color of the circle
                      borderStrokeWidth: 2.0, // Set the border width of the circle
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: markers,
                )
              ],
            ),
          )],
      ),
    );
  }
}