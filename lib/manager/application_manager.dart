import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prayer_times/manager/geo_location_helper.dart';
import 'package:prayer_times/ui/popup_dialog.dart';
import 'package:prayer_times/manager/prayer_times_helper.dart';
import 'package:prayer_times/global/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationManager{
  static ApplicationManager instance = ApplicationManager();
  AppTheme theme = DarkAppTheme();

  AnAction onThemeChange = AnAction();
  AnAction mainScreenRebuildRequest = AnAction();
  late PrayerTimesHelper prayerTimes;
  bool lightTheme = false;
  bool isInitialized = false;

  init(){
    instance.loadData();
  }
  //this method reload prayerTimes after geolocation call success in getting position.
  //still under dev.
  initPrayerData()  async {
     await determinePosition().then((position) {
       final calculationParameters = CalculationMethod.egyptian.getParameters();
       calculationParameters.madhab = Madhab.shafi;
       prayerTimes = PrayerTimesHelper(Coordinates(position.latitude, position.longitude), calculationParameters);
       isInitialized = true;
       mainScreenRebuildRequest.invoke();
       saveData();
     }).onError((error, stackTrace) {
       PopupDialog.showPopupDialogWithButton(
           "Oops",
           "The application need permission to access your current location, to calculate all prayers time."
               "\nPlease enable location serves or allow application to access your location from Settings.",
           "Ok",
           ()=>SystemChannels.platform.invokeMethod('SystemNavigator.pop')
       );
    }).timeout(const Duration(seconds: 10),onTimeout: (){
       PopupDialog.showPopupDialogWithButton(
           "Oops",
           "The application need permission to access your current location, to calculate all prayers time."
               "\nPlease enable location serves or allow application to access your location from Settings.",
           "Ok",
               ()=>SystemChannels.platform.invokeMethod('SystemNavigator.pop')
       );
     });
  }

  void saveData() async {
    print("Saving Data...");
    SharedPreferences userPref = await SharedPreferences.getInstance();
    userPref.clear();
    userPref.setBool("lightMode", lightTheme);
    userPref.setDouble("lat", prayerTimes.coordinates.latitude);
    userPref.setDouble("long", prayerTimes.coordinates.longitude);
    userPref.setInt("madhab", prayerTimes.calculationParameters.madhab.index);
    userPref.reload();
    print("Saved Data: ${userPref.getKeys().length}");
  }
  void loadData() async {
    print("Loading Data....");
    SharedPreferences userPref = await SharedPreferences.getInstance();
    userPref.reload();
    if(userPref.getKeys().isEmpty){
      instance.initPrayerData();
    }
    else{
      //-------Debug------
      print("Loaded Data: ${userPref.getKeys().toString()}");
      List<String> keys = userPref.getKeys().toList();
      for(int i = 0; i < keys.length; i++){
        print("${keys[i].toString()}: ${userPref.get(keys[i])}");
      }
      //-------------------

      final isLight = userPref.getBool("lightMode")?? false;
      if (isLight) {
        lightTheme = true;
        theme = LightAppTheme();
      }
      final long = userPref.getDouble("long")?? 0;
      final lat = userPref.getDouble("lat")?? 0;
      final madhab = userPref.getInt("madhab")?? 0;
      prayerTimes = PrayerTimesHelper(Coordinates(lat, long), CalculationMethod.values[madhab].getParameters());
      isInitialized = true;
      mainScreenRebuildRequest.invoke();
    }
  }
}

//a class for putting methods in list and fire it when you needed
class AnAction {
  final List<Function> _functions = List.empty(growable: true);

  void addAction(Function func) {
    _functions.add(func);
  }

  void removeAction(Function func) {
    _functions.remove(func);
  }

  void invoke() {
    for (Function func in _functions) {
      func.call();
    }
  }

  bool containAction(Function() func) {
    return _functions.contains(func);
  }
}