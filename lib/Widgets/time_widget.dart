
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:prayer_times/Data/app_theme_data.dart';
import 'package:prayer_times/Data/size_config.dart';
import 'package:provider/provider.dart';

class TimeWidget extends StatelessWidget{
  const TimeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var time = DateTime.now();
    //HijriCalendar.setLocal("ar");
    var timeHijri = HijriCalendar.now();

    SizeConfig sizeConfig = SizeConfig(context);

    var bigFontSize = 12 * sizeConfig.blockSmallest;
    var smallFontSize = 8 * sizeConfig.blockSmallest;
    var circleWidth = 50 * sizeConfig.blockSmallest;
    return Consumer<AppThemeData>(
      builder: (context, appThemeData, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: circleWidth,
                height: circleWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(circleWidth * .5),
                    color: appThemeData.selectedTheme.primaryColor
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat(DateFormat.ABBR_WEEKDAY).format(time), style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: bigFontSize),),
                      Text(DateFormat(DateFormat.DAY).format(time), style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: smallFontSize),),
                    ]
                ),
              ),
              Container(
                width: circleWidth,
                height: circleWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(circleWidth * .5),
                    color: appThemeData.selectedTheme.primaryColor
                ),
                padding: const EdgeInsetsDirectional.all(8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat(DateFormat.NUM_MONTH).format(time), style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: smallFontSize),),
                      Text(DateFormat(DateFormat.ABBR_MONTH).format(time), style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: bigFontSize),),
                    ]
                ),
              ),
              Container(
                width: circleWidth,
                height: circleWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(circleWidth * .5),
                    color: appThemeData.selectedTheme.primaryColor
                ),
                padding: const EdgeInsetsDirectional.all(8),
                child: Center(child: Text("${time.year}", style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: bigFontSize),)),
              ),
            ],
          ),
          SizedBox(height: 8 * sizeConfig.safeBlockSmallest,),
          Container(
            width: circleWidth * 3,
            height: circleWidth * .6,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(circleWidth * .1),
                color: appThemeData.selectedTheme.primaryColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${timeHijri.hDay} ", style: TextStyle(color: appThemeData.selectedTheme.textColor.withAlpha(180), fontSize: bigFontSize),),
                Text("${timeHijri.longMonthName}, ", style: TextStyle(color: appThemeData.selectedTheme.textColor.withAlpha(180),fontSize: bigFontSize),),
                Text("${timeHijri.hYear}", style: TextStyle(color: appThemeData.selectedTheme.textColor.withAlpha(180), fontSize: bigFontSize),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
