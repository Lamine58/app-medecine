// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new, use_build_context_synchronously
import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/auth/otp.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String lang = 'Français';
  final TextEditingController firstNamelController = TextEditingController();
  final TextEditingController lastNameontroller = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
      var response = await api.post('sign-in', {"first_name":firstNamelController.text,"last_name":lastNameontroller.text,"phone":phoneController.text,"email":emailController.text});

      if (response['status'] == 'success') {
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
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: firstNamelController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_first_name', lang),
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
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_first_name', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: lastNameontroller,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_last_name', lang),
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
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_last_name', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
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
                        paddingTop(15),
                        Container(
                          padding: EdgeInsets.only(left:15,right: 15,top: 10,bottom: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 233, 233, 233),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: InternationalPhoneNumberInput(
                            countries: ['FR', 'CG', 'MA', 'DZ', 'TN', 'CI', 'US', 'CA', 'IL'],
                            initialValue: PhoneNumber(isoCode: 'FR'),
                            hintText: translate('label_phone', lang),
                            onInputChanged: (PhoneNumber number) {
                              phoneController.text = number.phoneNumber!;
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            errorMessage: translate('error_phone', lang),
                            selectorTextStyle: TextStyle(color: Colors.black),
                            formatInput: false,
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
                        paddingTop(15),
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
                              child: Text(translate('submit_sign_in', lang),
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