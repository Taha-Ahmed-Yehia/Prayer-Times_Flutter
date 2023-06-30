import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prayer_times/Data/app_theme_data.dart';
import 'package:prayer_times/Data/size_config.dart';
import 'package:prayer_times/Models/AppTheme.dart';
import 'package:prayer_times/Screens/settings_screen.dart';
import 'package:prayer_times/Screens/theme_picker_screen.dart';
import 'package:prayer_times/Widgets/birds_animation.dart';
import 'package:prayer_times/Widgets/prayer_tile_widget.dart';
import 'package:provider/provider.dart';

import '../../Data/PrayerTimesData.dart';
import '../../Widgets/custom_menu_button.dart';
import '../../Widgets/next_prayer_widget.dart';
import '../../Widgets/time_widget.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig(context);
    return Consumer<AppThemeData>(
      builder: (context, appThemeData, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: appThemeData.selectedTheme.primaryColor,
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //top panel that contains current Date and Time widget and next prayer widget
                topPanel(sizeConfig, appThemeData.selectedTheme, context),
                SizedBox(height: 10 * sizeConfig.blockSizeVertical,),
                //bottom panel that show all prayers times
                bottomPanel(sizeConfig),
              ]
          )
      ),
    );
  }
  Widget topPanel(SizeConfig sizeConfig, AppTheme theme, BuildContext context) {
    final width = sizeConfig.screenWidth;
    final height = (sizeConfig.screenHeight * .4);
    final preyerTimesData = Provider.of<PrayerTimesData>(context,listen: false);
    return Container(
      width: width,
      height: height,
      padding: EdgeInsetsDirectional.only(top: sizeConfig.safeAreaBounds.top),
      decoration: BoxDecoration(
        color: theme.primaryDarkColor,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
        image: DecorationImage(
            image: const AssetImage("assets/Mosque_Background.png"),
            fit: BoxFit.fitHeight,
            scale: width / height,
            isAntiAlias: true,
            colorFilter: ColorFilter.mode(theme.textDarkColor.withAlpha(64), BlendMode.srcIn)
        ),
      ),
      child: Stack(
        children: [
          BirdsAnimation(width, height),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TimeWidget(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: sizeConfig.screenWidth * .5,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: MenuButton(
                        [
                          MenuItem("Reload", (){
                            preyerTimesData.reload();
                          }),
                          MenuItem("Settings", (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen(),));
                          }),
                          MenuItem("Themes", (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemePickerScreen(),));
                          }),
                        ], 
                        iconSize: 18,
                        icon: FontAwesomeIcons.bars,
                      )
                    ),
                  ),
                  const NextPrayerWidget(),
                  const SizedBox()
                ],
              )
            ],
          ),
        ],
      )
    );
  }

  Widget bottomPanel(SizeConfig sizeConfig,){
    return Consumer<PrayerTimesData>(
      builder: (context, prayerTimesData, child) { 
        bool isPrayerDataLoaded = prayerTimesData.isLoaded;
        print("Prayer Initialized: $isPrayerDataLoaded");
        if(!isPrayerDataLoaded) {
          return SizedBox();
        }
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PrayerTile(prayerIcon: CupertinoIcons.sun_dust, prayerName: isPrayerDataLoaded?prayerTimesData.fajrTime.prayerName:"", prayerTime: isPrayerDataLoaded? DateFormat(DateFormat.HOUR_MINUTE).format(prayerTimesData.fajrTime.prayerTime):""),
              PrayerTile(prayerIcon: CupertinoIcons.sunrise,prayerName: isPrayerDataLoaded?prayerTimesData.sunriseTime.prayerName:"", prayerTime: isPrayerDataLoaded? DateFormat(DateFormat.HOUR_MINUTE).format(prayerTimesData.sunriseTime.prayerTime):""),
              PrayerTile(prayerIcon: CupertinoIcons.sun_max, prayerName: isPrayerDataLoaded?prayerTimesData.dhuhrTime.prayerName:"", prayerTime: isPrayerDataLoaded? DateFormat(DateFormat.HOUR_MINUTE).format(prayerTimesData.dhuhrTime.prayerTime):""),
              PrayerTile(prayerIcon: CupertinoIcons.sun_haze, prayerName: isPrayerDataLoaded?prayerTimesData.asrTime.prayerName:"", prayerTime: isPrayerDataLoaded? DateFormat(DateFormat.HOUR_MINUTE).format(prayerTimesData.asrTime.prayerTime):""),
              PrayerTile(prayerIcon: CupertinoIcons.sunset,prayerName: isPrayerDataLoaded?prayerTimesData.maghribTime.prayerName:"", prayerTime: isPrayerDataLoaded? DateFormat(DateFormat.HOUR_MINUTE).format(prayerTimesData.maghribTime.prayerTime):""),
              PrayerTile(prayerIcon: CupertinoIcons.moon_stars,prayerName: isPrayerDataLoaded?prayerTimesData.ishaTime.prayerName:"", prayerTime: isPrayerDataLoaded? DateFormat(DateFormat.HOUR_MINUTE).format(prayerTimesData.ishaTime.prayerTime):""),
            ],
          ),
        );
      }
    );
  }
}
