
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/Data/app_theme_data.dart';
import '/Data/PrayerTimesData.dart';
import '/Data/size_config.dart';
import '/Data/time_provider.dart';
import 'package:provider/provider.dart';

class NextPrayerWidget extends StatelessWidget {
  const NextPrayerWidget({Key? key, required this.sizeConfig}) : super(key: key);
  final SizeConfig sizeConfig;
  @override
  Widget build(BuildContext context) {
    var size = 150 * sizeConfig.blockSmallest;
    return ChangeNotifierProvider<CurrentTime>(
      create: (context) => CurrentTime(),
      child: Consumer3<AppThemeData, PrayerTimesData, CurrentTime>(
        builder: (context, appThemeData, prayerTimesDate, currentTime, child) {

          if(!prayerTimesDate.isLoaded) {
            return CircularProgressIndicator(
              color: appThemeData.selectedTheme.secondaryColor,
            );
          }else{
            var currentPrayer = prayerTimesDate.getCurrentPrayer();
            var nextPrayer = prayerTimesDate.getNextPrayer();
            var time = currentTime.date;
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
                      Text(
                        nextPrayer.prayerName,
                        style: TextStyle(
                          color: appThemeData.selectedTheme.textColor, 
                          fontSize: 18 * sizeConfig.blockSmallest
                        ), 
                        textAlign: TextAlign.center,
                      ),
                      verticalSpacer(sizeConfig),
                      Text(
                        DateFormat(
                          DateFormat.HOUR_MINUTE).format(nextPrayer.prayerTime), 
                          style: TextStyle(color: appThemeData.selectedTheme.secondaryColor,
                          fontSize: 24 * sizeConfig.blockSmallest
                        ), 
                        textAlign: TextAlign.center
                      ),
                      verticalSpacer(sizeConfig),
                      Text(
                        (duration - timeDur).toString().split('.').first.padLeft(8, "0"), 
                        style: TextStyle(
                          color: appThemeData.selectedTheme.textColor.withAlpha(128),
                          fontSize: 18 * sizeConfig.blockSmallest
                        ), 
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        }
      ),
    );
  }

  SizedBox verticalSpacer(SizeConfig sizeConfig) => SizedBox(height: 10 * sizeConfig.blockSmallest);
}
