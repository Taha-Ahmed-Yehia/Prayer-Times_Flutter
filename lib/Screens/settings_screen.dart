
// ignore_for_file: non_constant_identifier_names

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import '/Data/app_theme_data.dart';
import '../Data/PrayerTimesData.dart';
import '../Data/size_config.dart';
import '../Enums/calculation_method_type.dart';
import '../Extensions/captlize_string.dart';
import '../Extensions/enum_to_string.dart';
import '../Widgets/General/back_to_prev_screen_button.dart';
import '/Widgets/General/custom_drop_down.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig.instanse;

    return Consumer2<AppThemeData, PrayerTimesData>(
      builder: (context, appThemeData, prayerTimesData, child) {
        var topBarSize = 24 * sizeConfig.blockSmallest;
        var fontSize = 12 * sizeConfig.blockSmallest;
        return Container(
          color: appThemeData.selectedTheme.primaryColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: appThemeData.selectedTheme.primaryColor,
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    _topBar(appThemeData, topBarSize),
                    settingPanel(
                      "Prayers Settings",
                      Column(
                        children: [
                          divider(appThemeData, sizeConfig.blockSmallest),
                          prayersCalculationMethod(appThemeData, fontSize, prayerTimesData),
                          divider(appThemeData, sizeConfig.blockSmallest),
                          prayersMadhab(appThemeData, fontSize, prayerTimesData),
                          divider(appThemeData, sizeConfig.blockSmallest),
                        ],
                      ),
                      appThemeData,
                      sizeConfig,
                      fontSize, 
                      prayerTimesData
                    ),
                    settingPanel(
                      "Prayers Time Adjustments",
                      Column(
                        children: [
                          prayerTimeAdjutmentTile(
                            "Fajr: ${prayerTimesData.prayerTimesModel.fajrTimeAdjustment}",
                            appThemeData, fontSize, sizeConfig, 
                            (value){prayerTimesData.adjustFajrTime(value);}
                          ),
                          divider(appThemeData, sizeConfig.blockSmallest),
                          prayerTimeAdjutmentTile(
                            "Sunrise: ${prayerTimesData.prayerTimesModel.sunriseTimeAdjustment}",
                            appThemeData, fontSize, sizeConfig, 
                            (value){prayerTimesData.adjustSunriseTime(value);}
                          ),
                          divider(appThemeData, sizeConfig.blockSmallest),
                          prayerTimeAdjutmentTile(
                            "Dhuhr: ${prayerTimesData.prayerTimesModel.dhuhrTimeAdjustment}",
                            appThemeData, fontSize, sizeConfig, 
                            (value){prayerTimesData.adjustDhuhrTime(value);}
                          ),
                          divider(appThemeData, sizeConfig.blockSmallest),
                          prayerTimeAdjutmentTile(
                            "Asr: ${prayerTimesData.prayerTimesModel.asrTimeAdjustment}",
                            appThemeData, fontSize, sizeConfig, 
                            (value){prayerTimesData.adjustAsrTime(value);}
                          ),
                          divider(appThemeData, sizeConfig.blockSmallest),
                          prayerTimeAdjutmentTile(
                            "Maghrib: ${prayerTimesData.prayerTimesModel.maghribTimeAdjustment}",
                            appThemeData, fontSize, sizeConfig, 
                            (value){prayerTimesData.adjustMaghribTime(value);}
                          ),
                          divider(appThemeData, sizeConfig.blockSmallest),
                          prayerTimeAdjutmentTile(
                            "Isha: ${prayerTimesData.prayerTimesModel.ishaTimeAdjustment}",
                            appThemeData, fontSize, sizeConfig, 
                            (value){prayerTimesData.adjustIshaTime(value);}
                          ),
                        ],
                      ),
                      appThemeData,
                      sizeConfig,
                      fontSize, 
                      prayerTimesData
                    ),
                  ],
          
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container settingPanel(String title, Widget chiled, AppThemeData appThemeData, SizeConfig sizeConfig, double fontSize, PrayerTimesData prayerTimesData) {
    return Container(
      decoration: BoxDecoration(
          color: appThemeData.selectedTheme.primaryDarkColor,
          borderRadius: BorderRadius.circular(10 * sizeConfig.blockSmallest)
      ),
      margin: EdgeInsets.only(left: 10 * sizeConfig.blockSmallest, right: 10 * sizeConfig.blockSmallest, top: 10 * sizeConfig.blockSmallest),
      padding: EdgeInsets.all(10 * sizeConfig.blockSmallest),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              color: appThemeData.selectedTheme.textColor,
              fontSize: fontSize
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10 * sizeConfig.blockSmallest),
          chiled,
        ],
      ),
    );
  }

  Widget prayersMadhab(AppThemeData appThemeData, double fontSize, PrayerTimesData prayerTimesData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Madhab",
          style: TextStyle(
              color: appThemeData.selectedTheme.textColor,
              fontSize: fontSize
          ),
          textAlign: TextAlign.center,
        ),
        CustomDropDown([
          CustomDropDownItem(Madhab.Hanafi.capitalize(), (){prayerTimesData.setCalculationMethodMadhab(Madhab.Hanafi);}),
          CustomDropDownItem(Madhab.Shafi.capitalize(), (){prayerTimesData.setCalculationMethodMadhab(Madhab.Shafi);})
        ],
          selectedItemID: prayerTimesData.prayerTimesModel.calculationMethodData.calculationParameters.madhab == Madhab.Hanafi ? 0 : 1,
        )
      ],
    );
  }

  Widget prayerTimeAdjutmentTile(String title, AppThemeData appThemeData, double fontSize, SizeConfig sizeConfig,Function(int value) fun){
    var size = 30 * sizeConfig.blockSmallest;
    var halfSize = size/2;
    return Container(
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(halfSize),
        color: appThemeData.selectedTheme.primaryLightColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appThemeData.selectedTheme.primaryLightColor,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(halfSize), bottomLeft: Radius.circular(halfSize)))
            ),
            onPressed: (){
              fun.call(-1);
            },
            child: Text(
              "-",
              style: TextStyle(
                  color: appThemeData.selectedTheme.textColor,
                  fontSize: fontSize
              ),
              textAlign: TextAlign.center,
            )
          ),
          Text(
            title,
            style: TextStyle(
                color: appThemeData.selectedTheme.textColor,
                fontSize: fontSize
            ),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appThemeData.selectedTheme.primaryLightColor,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(halfSize), bottomRight: Radius.circular(halfSize)))
            ),
            onPressed: (){
              fun.call(1);
            },
            child: Text(
              "+",
              style: TextStyle(
                  color: appThemeData.selectedTheme.textColor,
                  fontSize: fontSize
              ),
              textAlign: TextAlign.center,
            )
          ),
        ]
      ),
    );
  }

  Widget prayersTimeAdjustment(AppThemeData appThemeData, double fontSize, PrayerTimesData prayerTimesData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Calculation Method",
              style: TextStyle(
                  color: appThemeData.selectedTheme.textColor,
                  fontSize: fontSize
              ),
              textAlign: TextAlign.center,
            ),
            CustomDropDown([
              CustomDropDownItem(Madhab.Hanafi.capitalize(), (){prayerTimesData.setCalculationMethodMadhab(Madhab.Hanafi);}),
              CustomDropDownItem(Madhab.Shafi.capitalize(), (){prayerTimesData.setCalculationMethodMadhab(Madhab.Shafi);})
            ],
              selectedItemID: prayerTimesData.prayerTimesModel.calculationMethodData.calculationMethodType.index,
            )
          ],
        ),
      ],
    );
  }

  Widget prayersCalculationMethod(AppThemeData appThemeData, double fontSize, PrayerTimesData prayerTimesData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Calculation Method",
          style: TextStyle(
              color: appThemeData.selectedTheme.textColor,
              fontSize: fontSize
          ),
          textAlign: TextAlign.center,
        ),
        CustomDropDown(
          CalculationMethodType.values.map((e) {
            return CustomDropDownItem(e.name.enumNameToString(), (){prayerTimesData.setCalculationMethodData(e);});
          }).toList(),
          selectedItemID: prayerTimesData.prayerTimesModel.calculationMethodData.calculationMethodType.index,
        )
      ],
    );
  }

  Widget devMode_ClearCaches(AppThemeData appThemeData, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Clear Cache",
          style: TextStyle(
              color: appThemeData.selectedTheme.textColor,
              fontSize: fontSize
          ),
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appThemeData.selectedTheme.primaryLightColor,
            elevation: 1,
            shadowColor: appThemeData.selectedTheme.primaryDarkColor,
          ),
          onPressed: () async {
            var sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.clear();
          }, 
          child: Text(
            "Clear",
            style: TextStyle(
                color: appThemeData.selectedTheme.textColor,
                fontSize: fontSize
            ),
            textAlign: TextAlign.center,
          )
        )
      ],
    );
  }

  Widget _topBar(AppThemeData appThemeData, double topBarSize) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackToPrevScreenButton(
            appThemeData.selectedTheme.textColor,
            buttonSize: topBarSize),
          Text("Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appThemeData.selectedTheme.textColor,
              fontSize: topBarSize,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: appThemeData.selectedTheme.textDarkColor.withAlpha(128),
                  offset: const Offset(2, 2)
                )
              ]
            )
          ),
          SizedBox(width: topBarSize,)
        ],
      );
  }
  
  Divider divider(AppThemeData appThemeData, double blockSmallest) 
    => Divider(color: appThemeData.selectedTheme.primaryLightColor, indent: 50 * blockSmallest, endIndent: 50 * blockSmallest, thickness: 1 * blockSmallest,);

}