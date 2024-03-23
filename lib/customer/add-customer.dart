// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new, use_build_context_synchronously
import 'dart:io';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCustomer extends StatefulWidget {
  
  const AddCustomer({super.key});
  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

  String lang = 'Français';
  
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController medicsController = TextEditingController();
  late String originController = 'Origin';
  late String situationController = 'Situation';
  late String activityController = 'Activity';
  late String id = '';
  final TextEditingController diseasesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool displayPassword = false;
  late bool spinner = false;
  late Api api = Api();

  late List <String> origins = [];
  late List <String> situations = [];
  late List <String> activities = [];
  var base = '';
  
  var _avatarFile;
  var _avatar_url;

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
        origins = translate('origins',lang);
        situations = translate('situations',lang);
        activities = translate('activities',lang);
        originController = origins[0];
        situationController = situations[0];
        activityController = activities[0];
      });
    }else{
      setState(() {
        origins = translate('origins',lang);
        situations = translate('situations',lang);
        activities = translate('activities',lang);
        originController = origins[0];
        situationController = situations[0];
        activityController = activities[0];
      });
    }
  }

  Future<void> _pickImage() async {

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  _source(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(BootstrapIcons.image,color: primaryColor()),
                    paddingLeft(10),
                    Text(translate('open_library', lang),style: TextStyle(fontFamily: 'Roboto'))
                  ],
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: (){
                  _source(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(BootstrapIcons.camera,color: primaryColor()),
                    paddingLeft(10),
                    Text(translate('open_camera', lang),style: TextStyle(fontFamily: 'Roboto'))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

  }

  _source(source) async {

    Navigator.pop(context);
    final pickedImage = await ImagePicker().pickImage(source: source);

    var data;

    if (pickedImage != null) {
      data = await compressImage(pickedImage.path, targetSize: 250 * 1024);
    }

    setState(() {
      if (data != null) {
        _avatarFile = File(data.path);
      }
    });
  }
  
  void _saveData() async {
    
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
      
    var photo = _avatarFile;

    try {

      var response;

      if(photo!=null){

        response = await api.upload('add-customer',photo, {
          "email": emailController.text,
          "first_name": firstNameController.text,
          "phone": phoneController.text,
          "last_name": lastNameController.text,
          "location": locationController.text,
          "weight": weightController.text,
          "size": sizeController.text,
          "medics": medicsController.text,
          "origin": originController,
          "situation": situationController,
          "activity": activityController,
          "diseases": diseasesController.text
        });

      }else{
        
        response = await api.post('add-customer', {
          "email": emailController.text,
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "phone": phoneController.text,
          "location": locationController.text,
          "weight": weightController.text,
          "size": sizeController.text,
          "medics": medicsController.text,
          "origin": originController,
          "situation": situationController,
          "activity": activityController,
          "diseases": diseasesController.text
        });
      }
      

      if (response['status'] == 'success') {

        Navigator.pop(context);
        Navigator.pop(context);
        _showResultDialog(response['message']);

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
        title: Text(translate('add_patient', lang),style: TextStyle(fontSize: 15,color: Colors.white)),
        backgroundColor: primaryColor(),
        elevation: 0,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _pickImage();
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child:  Stack(
                                children: [
                                  _avatarFile != null
                                  ? CircleAvatar(
                                      backgroundImage:  FileImage(_avatarFile), 
                                      backgroundColor: grayColor(),
                                      radius: 60,
                                    )
                                  : (_avatar_url!= null && _avatar_url!='') ?
                                  CircleAvatar(
                                      backgroundImage:  NetworkImage(api.getbaseUpload()+_avatar_url), 
                                      backgroundColor: grayColor(),
                                      radius: 60,
                                    )
                                  : CircleAvatar(
                                    backgroundImage: const AssetImage('assets/images/avatar-2.png'), 
                                    backgroundColor: grayColor(),
                                    radius: 60,
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.only(top:7,right: 7,left:7,bottom: 7),
                                      decoration: BoxDecoration(
                                        color: primaryColor(),
                                        borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Icon(BootstrapIcons.camera_fill,color: Colors.white,)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: firstNameController,
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
                          keyboardType: TextInputType.name,
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
                          controller: lastNameController,
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
                          keyboardType: TextInputType.name,
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
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: locationController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_location', lang),
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
                          keyboardType: TextInputType.streetAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_location', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: weightController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('weight', lang),
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_weight', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: sizeController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('size', lang),
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_size', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        Container(
                          padding: EdgeInsets.all(15),
                          height: 55,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                              iconSize: 23,
                              value: originController,
                              onChanged: (String? data) {
                                setState(() {
                                  originController = data!;
                                });
                              },
                              items: origins
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        paddingTop(15),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          controller: medicsController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('medics', lang),
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
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_medics', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        Container(
                          padding: EdgeInsets.all(15),
                          height: 55,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                              iconSize: 23,
                              value: situationController,
                              onChanged: (String? data) {
                                setState(() {
                                  situationController = data!;
                                });
                              },
                              items: situations
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        paddingTop(15),
                        Container(
                          padding: EdgeInsets.all(15),
                          height: 55,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                              iconSize: 23,
                              value: activityController,
                              onChanged: (String? data) {
                                setState(() {
                                  activityController = data!;
                                });
                              },
                              items: activities
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        paddingTop(15),
                        TextFormField(
                          maxLines: 4,
                          textInputAction: TextInputAction.next,
                          controller: diseasesController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('diseases', lang),
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
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_diseases', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        ElevatedButton(
                          onPressed: spinner==true ? null : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _saveData();
                            } 
                          },
                          child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(translate('add', lang),
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