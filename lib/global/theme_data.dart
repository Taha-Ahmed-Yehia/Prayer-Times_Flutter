
import 'package:flutter/material.dart';

class AppTheme {
  Color primaryColor = Colors.white;
  Color secondaryColor = Colors.grey;

  Color primaryBackgroundColor = Colors.grey;
  Color secondaryBackgroundColor = Colors.grey;

  Color primaryFontColor = Colors.black;
  Color secondaryFontColor = Colors.black;
}

class DarkAppTheme extends AppTheme{
  DarkAppTheme(){
    primaryColor = hexColor("f4b028");
    secondaryColor = hexColor("cf5e02");
    primaryBackgroundColor = hexColor("ff040706");
    secondaryBackgroundColor = hexColor("ff5b1707");
    primaryFontColor = Colors.white;
    secondaryFontColor = Colors.white60;
  }

}
class LightAppTheme extends AppTheme{
  LightAppTheme(){
    primaryColor = Colors.white;
    secondaryColor = Colors.blue.shade50;
    primaryBackgroundColor = Colors.grey.shade400;
    secondaryBackgroundColor = Colors.blue.shade50;
    primaryFontColor = Colors.black;
    secondaryFontColor = Colors.black;
  }
}

Color hexColor(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
  hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}