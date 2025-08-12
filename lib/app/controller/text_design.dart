import 'package:flutter/material.dart';

class TextDesign{
  static TextStyle whiteTextStyle(double size){
    return TextStyle(color:Colors.white,fontSize: size,fontWeight: FontWeight.w600);
  }

  static TextStyle bodyMediumTextStyle(double size){
    return TextStyle(color:Colors.black,fontSize: size,fontWeight: FontWeight.bold);
  }
  static TextStyle bodySmallTextStyle(double size){
    return TextStyle(color:Colors.black54,fontSize: size,fontWeight: FontWeight.w500);
  }
  static TextStyle hintTextStyle(double size){
    return TextStyle(color:Colors.black54,fontSize: size,fontWeight: FontWeight.w500);
  }
}