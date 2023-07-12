// ignore_for_file: file_names

import 'dart:convert';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:prayer_times/Enums/calculation_method_type.dart';
import 'package:prayer_times/Extensions/captlize_string.dart';

import '../Models/calculation_method_model.dart';
import '../Models/prayer_model.dart';
import '../Models/prayer_times_model.dart';
import '../manager/geo_location_helper.dart';
import 'constants.dart';

class PrayerTimesData extends ChangeNotifier {
  late PrayerTimesModel prayerTimesModel;
  late PrayerTimes prayerTimes;
  late DateTime initDate;

  late tz.Location timezone;

  late PrayerModel fajrTime;
  late PrayerModel sunriseTime;
  late PrayerModel dhuhrTime;
  late PrayerModel asrTime;
  late PrayerModel maghribTime;
  late PrayerModel ishaTime;

  bool isLoaded = false;

  PrayerTimesData() {
    prayerTimesModel = PrayerTimesModel(
      position: Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0), 
      calculationMethodData: CalculationMethodModel(calculationMethodType: CalculationMethodType.muslim_World_League),
      madhab: Madhab.Hanafi,
      fajrTimeAdjustment: 0, 
      sunriseTimeAdjustment: 0, 
      dhuhrTimeAdjustment: 0, 
      asrTimeAdjustment: 0, 
      maghribTimeAdjustment: 0, 
      ishaTimeAdjustment: 0
    );
    prayerTimesModel.calculationMethodData.calculationParameters.madhab = Madhab.Hanafi;
    load();
  }
  void gpsLoad() async {
    var positonError = false;
    prayerTimesModel.position = await determinePosition(showServiceUnenabledMessage: !isLoaded).onError((error, stackTrace) {
      if (kDebugMode) {
        print(stackTrace);
      }
      positonError = true;
      return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      positonError = true;
      return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    },);

    if(!positonError){
      String dtz = await FlutterNativeTimezone.getLocalTimezone();
      timezone = tz.getLocation(dtz);
      initDate = tz.TZDateTime.from(DateTime.now(), timezone);
      var coordinates = Coordinates(prayerTimesModel.position.latitude, prayerTimesModel.position.longitude);
      prayerTimes = PrayerTimes(coordinates, initDate, prayerTimesModel.calculationMethodData.calculationParameters);

      initPrayers();
      save();
      isLoaded = true;
      notifyListeners();
    }
  }
  
  void reload(){
    isLoaded = false;
    load();
  }

  void update() async {
    String dtz = await FlutterNativeTimezone.getLocalTimezone();
    timezone = tz.getLocation(dtz);
    initDate = tz.TZDateTime.from(DateTime.now(), timezone);

    var coordinates = Coordinates(prayerTimesModel.position.latitude, prayerTimesModel.position.longitude);

    prayerTimes = PrayerTimes(coordinates, initDate, prayerTimesModel.calculationMethodData.calculationParameters);

    initPrayers();
    
    notifyListeners();
  }

  void initPrayers(){
    fajrTime = PrayerModel("Fajr", tz.TZDateTime.from(prayerTimes.fajr??initDate, timezone).add(Duration(minutes: prayerTimesModel.fajrTimeAdjustment)));
    sunriseTime = PrayerModel("Alshuruq",tz.TZDateTime.from(prayerTimes.sunrise??initDate, timezone).add(Duration(minutes: prayerTimesModel.sunriseTimeAdjustment)));
    dhuhrTime = PrayerModel(
      DateFormat(DateFormat.ABBR_WEEKDAY).format(initDate) == "Fri"? "Aljameah" : "Dhuhr", 
      tz.TZDateTime.from(prayerTimes.dhuhr??initDate, timezone).add(Duration(minutes: prayerTimesModel.dhuhrTimeAdjustment))
    );
    asrTime = PrayerModel("Asr",tz.TZDateTime.from(prayerTimes.asr??initDate, timezone).add(Duration(minutes: prayerTimesModel.asrTimeAdjustment)));
    maghribTime = PrayerModel("Maghrib",tz.TZDateTime.from(prayerTimes.maghrib??initDate, timezone).add(Duration(minutes: prayerTimesModel.maghribTimeAdjustment)));
    ishaTime = PrayerModel("Isha",tz.TZDateTime.from(prayerTimes.isha??initDate, timezone).add(Duration(minutes: prayerTimesModel.ishaTimeAdjustment)));
  }

  PrayerModel getCurrentPrayer(){
    var date = tz.TZDateTime.from(DateTime.now(), timezone);
    String prayerName = prayerTimes.currentPrayer(date: date);
    var prayerTime =  tz.TZDateTime.from(prayerTimes.timeForPrayer(prayerName)??initDate, timezone);
    if(prayerName == Prayer.Dhuhr && DateFormat(DateFormat.ABBR_WEEKDAY).format(date) == "Fri"){
      prayerName = "Aljameah";
    }
    prayerName = prayerName.capitalize();
    return PrayerModel(prayerName, prayerTime);
  }

  PrayerModel getNextPrayer(){
    var date = tz.TZDateTime.from(DateTime.now(), timezone);
    String prayerName = prayerTimes.nextPrayer(date: date);
    var prayerTime =  tz.TZDateTime.from(prayerTimes.timeForPrayer(prayerName)??initDate, timezone);
    if(prayerName == Prayer.FajrAfter){
      date = date.add(const Duration(days: 1));
      prayerName = prayerTimes.nextPrayer(date: date);
      prayerTime =  tz.TZDateTime.from(prayerTimes.timeForPrayer(prayerName)??initDate, timezone);
    }
    if(prayerName == Prayer.Dhuhr && DateFormat(DateFormat.ABBR_WEEKDAY).format(date) == "Fri"){
      prayerName = "Aljameah";
    }
    prayerName = prayerName.capitalize();
    return PrayerModel(prayerName, prayerTime);
  }
  
  void load() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var data = sharedPreferences.getString(prayerTimesDataSaveKey);
    //print(data);
    if(data != null){
      if(data.isNotEmpty){
        try{
          prayerTimesModel = PrayerTimesModel.fromJson(jsonDecode(data));
          update();
          isLoaded = true;
          notifyListeners();
        } catch(e) {
          gpsLoad();
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }
    gpsLoad();
  }
  
  void save() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    var data = prayerTimesModel;
    var pref = jsonEncode(data);
    sharedPreferences.setString(prayerTimesDataSaveKey, pref);
  }

  void setCalculationMethodData(CalculationMethodType calculationMethodType){
    prayerTimesModel.calculationMethodData = CalculationMethodModel(calculationMethodType: calculationMethodType);
    save();
    update();
  }
  void setCalculationMethodMadhab(String madhab){
    if(madhab == Madhab.Shafi){
      prayerTimesModel.calculationMethodData.calculationParameters.madhab = Madhab.Shafi;
    }else{
      prayerTimesModel.calculationMethodData.calculationParameters.madhab = Madhab.Hanafi;
    }
    save();
    update();
  }

  void adjustFajrTime(int value) {
    prayerTimesModel.fajrTimeAdjustment += value;
    update();
    save();
  }
  void adjustSunriseTime(int value) {
    prayerTimesModel.sunriseTimeAdjustment += value;
    update();
    save();
  }
  void adjustDhuhrTime(int value) {
    prayerTimesModel.dhuhrTimeAdjustment += value;
    update();
    save();
  }
  void adjustAsrTime(int value) {
    prayerTimesModel.asrTimeAdjustment += value;
    update();
    save();
  }
  void adjustMaghribTime(int value) {
    prayerTimesModel.maghribTimeAdjustment += value;
    update();
    save();
  }
  void adjustIshaTime(int value) {
    prayerTimesModel.ishaTimeAdjustment += value;
    update();
    save();
  }
}