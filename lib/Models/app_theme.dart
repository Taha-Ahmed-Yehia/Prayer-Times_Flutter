
import 'package:flutter/material.dart';

class AppTheme{
  //theme name
  String name;
  //primaries
  Color primaryColor = const Color.fromARGB(255, 255, 128, 128);
  Color primaryLightColor = const Color.fromARGB(255, 255, 200, 200);
  Color primaryDarkColor = Colors.redAccent;
  //secondaries
  Color secondaryColor = Colors.white;
  //text
  Color textColor = Colors.white;
  Color textDarkColor = Colors.black;
  bool isDefault = false;
  int id = 0;
  static int _id = 0;

  AppTheme({
    required this.name,

    required this.primaryColor,
    required this.primaryLightColor,
    required this.primaryDarkColor,

    required this.secondaryColor,

    required this.textColor,
    required this.textDarkColor,

    this.isDefault = false
    }
  ) {
    _id++;
    id = _id;
    //print(id);
  }
  AppTheme clone(){
    return AppTheme(
      name: name,
      primaryColor: primaryColor,
      primaryLightColor: primaryLightColor,
      primaryDarkColor: primaryDarkColor,
      secondaryColor: secondaryColor,
      textColor: textColor,
      textDarkColor: textDarkColor,
      isDefault: isDefault
    );
  }

  factory AppTheme.fromJson(Map<String, dynamic> json) =>
      AppTheme(
        name:json['name'],
        primaryColor:Color(json['primaryColor']),
        primaryLightColor:Color(json['primaryLightColor']),
        primaryDarkColor:Color(json['primaryDarkColor']),
        secondaryColor:Color(json['secondaryColor']),
        textColor:Color(json['textColor']),
        textDarkColor:Color(json['textDarkColor'])
      );

  Map<String, dynamic> toJson()=> {
    "name":name,
    "primaryColor":primaryColor.value,
    "primaryLightColor":primaryLightColor.value,
    "primaryDarkColor":primaryDarkColor.value,
    "secondaryColor":secondaryColor.value,
    "textColor":textColor.value,
    "textDarkColor":textDarkColor.value
  };
}