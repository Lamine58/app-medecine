// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:app_medcine/api/api.dart';
import 'package:app_medcine/dashboard/dashboard.dart';
import 'package:app_medcine/function/function.dart';
import 'package:app_medcine/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class Otp extends StatefulWidget {
  final phone;
  const Otp(this.phone,{super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {

  String lang = 'Français';
  int _otpCodeLength = 4;
  bool _isLoadingButton = false;
  bool _enableButton = false;
  String _otpCode = "1234";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController = new TextEditingController();
  late Api api = Api();

  _getSignatureCode() async {
    String? signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }
  
  @override
  void initState() {
    super.initState();
    init();
    _getSignatureCode();
    _startListeningSms();
  }

  _startListeningSms()  {
     SmsVerification.startListeningSms().then((message) {
      setState(() {
        _otpCode = SmsVerification.getCode(message, intRegex);
        textEditingController.text = _otpCode;
        _onOtpCallBack(_otpCode, true);
      });
    });
  }
  
  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
  }

  _onOtpCallBack(String otpCode, bool isAutofill) {
    setState(() {
      this._otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        _enableButton = false;
        _isLoadingButton = true;
        _verifyOtpCode();
      } else if (otpCode.length == _otpCodeLength && !isAutofill) {
        _enableButton = true;
        _isLoadingButton = false;
      } else {
        _enableButton = false;
      }
    });
  }

  
  _onSubmitOtp() {
    setState(() {
      _isLoadingButton = !_isLoadingButton;
      _verifyOtpCode();
    });
  }
  
  _verifyOtpCode() async {
    
    try {

      var response = await api.post('verify-code', {"phone":widget.phone,'hash':textEditingController.text});

      if(response['status'] == 'success'){
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cutomerData', jsonEncode(response));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Dashboard()),(routes)=>false);
      }else{
        setState(() {
          _isLoadingButton = false;
          _enableButton = false;
        });
        _showResultDialog(response['message']);
      }

    } catch (error) {
      setState(() {
        _isLoadingButton = false;
        _enableButton = false;
      });
      _showResultDialog('Erreur: $error');
    }
  }
  
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: primaryColor()),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  Widget _setUpButtonChild() {
    if (_isLoadingButton) {
      return Container(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Text(
        translate('verify', lang),
        style: TextStyle(color: Colors.white),
      );
    }
  }

  _onClickRetry() async {

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

      var response = await api.post('send-code', {"phone":widget.phone});
      Navigator.pop(context);
      _showResultDialog(response['message']);

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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor(),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body:  Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(translate('text_otp', lang),textAlign: TextAlign.center),
                paddingTop(30),
                TextFieldPin(
                  textController: textEditingController,
                  autoFocus: true,
                  codeLength: _otpCodeLength,
                  alignment: MainAxisAlignment.center,
                  defaultBoxSize: 50.0,
                  margin: 10,
                  selectedBoxSize: 50.0,
                  textStyle: TextStyle(fontSize: 16),
                  defaultDecoration: _pinPutDecoration.copyWith(
                  border: Border.all(
                    color: Theme.of(context)
                    .primaryColor
                    .withOpacity(0.6))),
                  selectedDecoration: _pinPutDecoration,
                  onChange: (code) {
                    _onOtpCallBack(code,false);
                  }
                ),
                paddingTop(20),
                Container(
                  height: 50,
                  width: double.maxFinite,
                  child: MaterialButton(
                    onPressed: _enableButton ? _onSubmitOtp : null,
                    child: _setUpButtonChild(),
                    color: primaryColor(),
                    disabledColor: primaryColor(),
                  ),
                ),
                paddingTop(20),
                Container(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: _onClickRetry,
                    child: Text(
                      translate('retry', lang)
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}