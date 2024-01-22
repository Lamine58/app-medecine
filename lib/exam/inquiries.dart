import 'package:app_medcine/fuction/function.dart';
import 'package:app_medcine/fuction/translate.dart';
import 'package:flutter/material.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inquiries extends StatefulWidget {

  final List<String> requirements;

  const Inquiries(this.requirements, {super.key});

  @override
  State<Inquiries> createState() => _InquiriesState();
}

class _InquiriesState extends State<Inquiries> {

  String lang = 'Français';

  List<String> requirements = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor(),
        toolbarHeight: 45,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          translate('inquiry', lang),
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white),
          ),
      ),
      body: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.document_scanner_rounded,
                size: 36,
                color: Color(0xff00a6ff),
              ),
              Icon(
                Icons.file_download_done_rounded,
                size: 36,
                color: Color(0xff00a6ff),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              translate('send_doc', lang),
              style: TextStyle(
                color: primaryColor(),
              ),
            ),
          ),
        ]
      ),
    );
  }
  
}
