
import '../Extensions/captlize_string.dart';

extension EnumToName on String {
  enumNameToString({String splitPattern = '_'}){
    String name = toString();
    var splitString = name.split(splitPattern);
    for(int i = 0; i < splitString.length; i++){
      var sString = splitString[i].capitalize();
      if(i==0) {
        name = sString;
      } else {
        name += " $sString";
      }
    }
    return name;
  }
}