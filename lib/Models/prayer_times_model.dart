
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'calculation_method_model.dart';

class PrayerTimesModel {
  Position position;
  CalculationMethodModel calculationMethodData;
  String madhab;

  int fajrTimeAdjustment;
  int sunriseTimeAdjustment;
  int dhuhrTimeAdjustment;
  int asrTimeAdjustment;
  int maghribTimeAdjustment;
  int ishaTimeAdjustment;

  PrayerTimesModel({
    required this.position,
    required this.calculationMethodData,
    required this.madhab,
    required this.fajrTimeAdjustment,
    required this.sunriseTimeAdjustment,
    required this.dhuhrTimeAdjustment,
    required this.asrTimeAdjustment,
    required this.maghribTimeAdjustment,
    required this.ishaTimeAdjustment,
  });
  Map<String, dynamic> toMap() {
    return {
      'position': position.toJson(),
      'calculationMethodData': calculationMethodData.toMap(),
      'madhab': madhab,
      'fajrTimeAdjustment': fajrTimeAdjustment,
      'sunriseTimeAdjustment': sunriseTimeAdjustment,
      'dhuhrTimeAdjustment': dhuhrTimeAdjustment,
      'asrTimeTimeAdjustment': asrTimeAdjustment,
      'maghribTimeAdjustment': maghribTimeAdjustment,
      'ishaTimeAdjustment': ishaTimeAdjustment,
    };
  }
  factory PrayerTimesModel.fromMap(Map<String, dynamic> map) {
    return PrayerTimesModel(
      position: Position.fromMap(map['position']),
      calculationMethodData: CalculationMethodModel.fromMap(map['calculationMethodData']),
      madhab: map['madhab'],
      fajrTimeAdjustment: map['fajrTimeAdjustment']?? 0,
      sunriseTimeAdjustment: map['sunriseTimeAdjustment']?? 0,
      dhuhrTimeAdjustment: map['dhuhrTimeAdjustment']?? 0,
      asrTimeAdjustment: map['asrTimeTimeAdjustment']?? 0,
      maghribTimeAdjustment: map['maghribTimeAdjustment']?? 0,
      ishaTimeAdjustment: map['ishaTimeAdjustment']?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrayerTimesModel.fromJson(String source) => PrayerTimesModel.fromMap(json.decode(source));
}
