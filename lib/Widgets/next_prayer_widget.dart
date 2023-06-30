
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prayer_times/Data/app_theme_data.dart';
import 'package:prayer_times/Data/PrayerTimesData.dart';
import 'package:prayer_times/Data/size_config.dart';
import 'package:provider/provider.dart';

class NextPrayerWidget extends StatelessWidget {
  const NextPrayerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig(context);
    var size = 150*sizeConfig.blockSmallest;
    var timer = Timer(Duration(seconds: 1), () {
            });
    return ChangeNotifierProvider<UpdateWidget>(
      create: (context) => UpdateWidget(),
      child: Consumer3<AppThemeData, PrayerTimesData, UpdateWidget>(
        builder: (context, appThemeData, prayerTimesDate, updateWidget, child) {
          if(!prayerTimesDate.isLoaded) return SizedBox();
            if(timer.isActive) {
              timer.cancel();
          }
          timer = Timer(Duration(seconds: 1), () {
            updateWidget.update();
          });
          var currentPrayer = prayerTimesDate.getCurrentPrayer();
          var nextPrayer = prayerTimesDate.getNextPrayer();
          var time = DateTime.now();
          var duration = nextPrayer.prayerTime.difference(currentPrayer.prayerTime);
          var timeDur = time.difference(currentPrayer.prayerTime);
          return Stack(
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: timeDur.inSeconds/ duration.inSeconds,
                  strokeWidth: 4,
                  color: appThemeData.selectedTheme.secondaryColor,
                  backgroundColor: appThemeData.selectedTheme.primaryLightColor,
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(nextPrayer.prayerName, style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 18 * sizeConfig.blockSmallest), textAlign: TextAlign.center,),
                    Text(DateFormat(DateFormat.HOUR_MINUTE).format(nextPrayer.prayerTime), style: TextStyle(color: appThemeData.selectedTheme.secondaryColor,fontSize: 24 * sizeConfig.blockSmallest), textAlign: TextAlign.center),
                    Text((duration - timeDur).toString().split('.').first.padLeft(8, "0"), style: TextStyle(color: appThemeData.selectedTheme.textColor.withAlpha(128),fontSize: 18 * sizeConfig.blockSmallest), textAlign: TextAlign.center,),
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
class UpdateWidget extends ChangeNotifier
{
  update() {
    notifyListeners();
  }
}