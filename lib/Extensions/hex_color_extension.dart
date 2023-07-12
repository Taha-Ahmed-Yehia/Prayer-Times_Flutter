
import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    Color color;
    try{
      color = Color(int.parse(buffer.toString(), radix: 16));
    }catch(e){
      color = Colors.white;
    }
    return color;
  }
}
extension ColorExention on Color{
  toHex(){
    return value.toRadixString(16).padLeft(8, '0').replaceFirst('', '#');
  }
}