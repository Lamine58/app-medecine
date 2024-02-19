// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/auth/otp.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String lang = 'Français';
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool displayPassword = false;
  late bool spinner = false;
  late Api api = Api();

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

  
  void _auth() async {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(),
            paddingLeft(20),
            Text(translate('wait',lang))
          ],
        ),
      ),
    );

    try {
      var response = await api.post('login',{"phone":phoneController.text});

      if (response['status'] == 'success') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cutomerData', jsonEncode(response));
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Otp(phoneController.text)),(route)=>false);
      } else {
        Navigator.pop(context);
        _showResultDialog(response['message']);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error');
    }

  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        title: Text('Réponse',style: TextStyle(fontSize: 20),),
        content: Text(result,style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        toolbarHeight: 40,
        backgroundColor: primaryColor(),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25))
          ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  child: logo_blue(200),
                  alignment: Alignment.centerLeft,
                ),
                paddingTop(10),
                Text(translate('login_text', lang)),
                paddingTop(20),
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left:15,right: 15,top: 10,bottom: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 233, 233, 233),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: InternationalPhoneNumberInput(
                            initialValue: PhoneNumber(isoCode: 'CI'),
                            hintText: translate('label_phone', lang),
                            onInputChanged: (PhoneNumber number) {
                              phoneController.text = number.phoneNumber!;
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            errorMessage: translate('error_phone', lang),
                            selectorTextStyle: TextStyle(color: Colors.black),
                            formatInput: true,
                            inputBorder: InputBorder.none,
                            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                            onSaved: (PhoneNumber number) {
                              setState(() {
                                phoneController.text = number.phoneNumber!;
                              });
                            },
                            searchBoxDecoration: InputDecoration(
                              hintText: translate('search', lang),
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            ),
                          ),
                        ),
                        paddingTop(20),
                        ElevatedButton(
                          onPressed: spinner==true ? null : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _auth();
                            } 
                          },
                          child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(translate('submit_login', lang),
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        paddingTop(20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(),
                            ),
                            paddingLeft(5),
                            Text(translate('or', lang)),
                            paddingLeft(5),
                            Expanded(
                              child: Divider(),
                            )
                          ],
                        ),
                        paddingTop(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: Icon(BootstrapIcons.facebook,color: Colors.white),
                              decoration: BoxDecoration(
                                color: Color(0xff1877F2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            paddingLeft(10),
                            Container(
                              height: 50,
                              width: 50,
                              child: Icon(BootstrapIcons.twitter_x,color: Colors.white),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            paddingLeft(10),
                            Container(
                              height: 50,
                              width: 50,
                              child: Icon(BootstrapIcons.google,color: Colors.white),
                              decoration: BoxDecoration(
                                color: Color(0xffDD4B39),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            paddingLeft(10),
                            Container(
                              height: 50,
                              width: 50,
                              child: Icon(BootstrapIcons.apple,color: Colors.white),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            paddingLeft(10),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}