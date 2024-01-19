import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter/material.dart';

primaryColor() {
  return Color(0xff00a6ff);
}

paddingTop(height){
  return SizedBox(height: height.toDouble());
}

paddingLeft(width){
  return SizedBox(width: width.toDouble());
}

logo(width){
  return Image.asset('assets/images/logo-marvel.png',width: width.toDouble());
}

logo_blue(width){
  return Image.asset('assets/images/logo-marvel-blue.png',width: width.toDouble());
}

statusBar(){
  return AppBar(
    toolbarHeight: 0,
    elevation: 0,
    backgroundColor: primaryColor(),
  );
}

Future<File> compressImage(String imagePath, {int targetSize = 0}) async {
  File compressedImage;
  int quality = 100;

  do {
    var compressedData = await FlutterNativeImage.compressImage(
      imagePath,
      quality: quality,
    );

    compressedImage = File(compressedData.path);

    if (targetSize > 0 && compressedImage.lengthSync() > targetSize) {
      quality -= 10; // Decrease quality by 10 units if the size is still too large
    }
  } while (targetSize > 0 && compressedImage.lengthSync() > targetSize && quality > 0);

  return compressedImage;
}