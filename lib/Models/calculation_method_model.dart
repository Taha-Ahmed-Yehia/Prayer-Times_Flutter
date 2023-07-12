
import 'dart:convert';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:prayer_times/Extensions/enum_to_string.dart';
import '../Enums/calculation_method_type.dart';

class CalculationMethodModel {
  CalculationMethodType calculationMethodType;
  
  late CalculationParameters calculationParameters;
  late String methodName;

  CalculationMethodModel({
    required this.calculationMethodType,
  }) {
    methodName = calculationMethodType.name.enumNameToString();
    calculationParameters = _getCalculationMethod(calculationMethodType);

  }

  CalculationParameters _getCalculationMethod(CalculationMethodType calculationMethodType){
    switch(calculationMethodType){
      case CalculationMethodType.muslim_World_League:
        return CalculationMethod.MuslimWorldLeague();
      case CalculationMethodType.egyptian:
        return CalculationMethod.Egyptian();
      case CalculationMethodType.karachi:
        return CalculationMethod.Karachi();
      case CalculationMethodType.umm_AlQura:
        return CalculationMethod.UmmAlQura();
      case CalculationMethodType.dubai:
        return  CalculationMethod.Dubai();
      case CalculationMethodType.moon_sighting_Committee:
        return CalculationMethod.MoonsightingCommittee();
      case CalculationMethodType.north_America:
        return CalculationMethod.NorthAmerica();
      case CalculationMethodType.kuwait:
        return CalculationMethod.Kuwait();
      case CalculationMethodType.qatar:
        return CalculationMethod.Qatar();
      case CalculationMethodType.singapore:
        return CalculationMethod.Singapore();
      case CalculationMethodType.tehran:
        return CalculationMethod.Tehran();
      case CalculationMethodType.turkey:
        return  CalculationMethod.Turkey();
      case CalculationMethodType.morocco:
        return CalculationMethod.Morocco();
      case CalculationMethodType.other:
        return CalculationMethod.Other();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'calculationMethodType': calculationMethodType.index,
    };
  }

  factory CalculationMethodModel.fromMap(Map<String, dynamic> map) {
    return CalculationMethodModel(
      calculationMethodType: CalculationMethodType.values[map['calculationMethodType']],
    );
  }

  String toJson() => json.encode(toMap());

  factory CalculationMethodModel.fromJson(String source) => CalculationMethodModel.fromMap(json.decode(source));
}
