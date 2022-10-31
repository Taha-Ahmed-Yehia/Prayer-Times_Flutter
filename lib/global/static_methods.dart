String formatTime(int hour, int minute, {bool twelveHourTime = true}){
  int h = hour;
  int m = minute;
  if(h == 0){
    h = 12;
  }
  String min = m > 9 ? "$m" : "0$m";
  String hr = h < 10 ? "0$h" : h > 12 ? "${(12-h).abs()}" : "$h";
  String timeOfDay = twelveHourTime ? (h > 11 ? "PM" : "AM") : "";
  return  "$hr:$min $timeOfDay";
}
String dateFormatToTime(DateTime dateTime,{bool twelveHourTime = true}){
  int h = dateTime.hour;
  if(h > 12){
    h = (12-h).abs();
  }
  int m = dateTime.minute;
  if(h == 0){
    h = 12;
  }
  String min = m > 9 ? "$m" : "0$m";
  String hr = h < 10 ? "0$h" : "$h";
  String timeOfDay = twelveHourTime ? (h > 11 ? "PM" : "AM") : "";
  return  "$hr:$min $timeOfDay";
}