// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/auth/otp.dart';
import 'package:app_medcine/auth/sign-in.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String lang = 'Français';
  final TextEditingController emailController = TextEditingController();
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
      var response = await api.post('login',{"email":emailController.text});

      if (response['status'] == 'success') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cutomerData', jsonEncode(response));
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Otp(emailController.text)),(route)=>false);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  child: logo_blue(200),
                  alignment: Alignment.centerLeft,
                ),
                paddingTop(10),
                Text(translate('login_text', lang),textAlign: TextAlign.start,),
                paddingTop(20),
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_email', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_email', lang);
                            }
                            return null;
                          },
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
                        paddingTop(10),
                        SizedBox(
                          width: double.infinity, 
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(91, 0, 166, 255),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ),
                              );
                            },
                            child: Text(translate('text_sign',lang),style: TextStyle(color: Color.fromARGB(255, 1, 121, 185),fontFamily: 'Toboggan'),textAlign: TextAlign.center)
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