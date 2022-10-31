import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:prayer_times/manager/prayer_times_helper.dart';
import 'package:prayer_times/responsive/responsive_layout.dart';
import 'package:prayer_times/global/theme_data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../manager/application_manager.dart';
import '../responsive/responsive_layout.dart';
import '../global/static_methods.dart';

class NextPrayerWidget extends StatefulWidget{
  NextPrayerWidget({Key? key, double? height}) : super(key: key) {
    if(height != null){
      this.height = height;
    }
  }
  double height = -1;
  @override
  State<StatefulWidget> createState() {
    return _NextPrayerWidget();
  }
}

class _NextPrayerWidget extends State<NextPrayerWidget>  with SingleTickerProviderStateMixin {
  Timer? timer;
  String nextPrayerName = "";
  String nextPrayerTime = "";
  String timeUntilNextPrayer = "";
  double percentToNextPrayer = 0;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setState((){
      _refresh();
    }));
  }
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
  void _refresh(){
    PrayerTimesHelper prayerTimes = ApplicationManager.instance.prayerTimes;
    prayerTimes.updatePrayers();
    final now = DateTime.now();
    PrayerData currentPrayer = prayerTimes.getCurrentPrayer();
    PrayerData nextPrayer =  prayerTimes.getNextPrayer();

    nextPrayerName = nextPrayer.prayer.name;
    Duration npDuration = nextPrayer.prayerDatTime.difference(now);
    //print("CP: ${currentPrayer.name} ${dateFormatToTime(currentPrayer.prayerDatTime)}, NP: $nextPrayerName ${dateFormatToTime(nextPrayer.prayerDatTime)}");
    percentToNextPrayer = 1 - (npDuration.inSeconds / nextPrayer.prayerDatTime.difference(currentPrayer.prayerDatTime).inSeconds).clamp(0, 1);
    //print(percentToNextPrayer);
    timeUntilNextPrayer = _printDuration(npDuration);
    nextPrayerTime = dateFormatToTime(nextPrayer.prayerDatTime);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contexts, constraints) =>
    circleTimeThemeWidget(constraints));
  }

  Widget circleTimeThemeWidget(BoxConstraints constraints){
    Size screenSize = ResponsiveLayout.screenSize;
    double w = constraints.maxWidth;
    double h = widget.height;
    if(h <= 0) {
      h = screenSize.height;
    }
    double radius = (w > h) ? (h * .45) : (w * .45);
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: CircularPercentIndicator(
              key: GlobalKey(),
              radius: radius,
              reverse: false,
              backgroundColor: hexColor("64cf5e02"),
              progressColor: hexColor("fff4b028"),
              circularStrokeCap: CircularStrokeCap.round,
              percent: percentToNextPrayer
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customNText(nextPrayerName, ApplicationManager.instance.theme.primaryFontColor, radius/3.5),
              customNText(nextPrayerTime, ApplicationManager.instance.theme.primaryFontColor, radius/3),
              customNText("متبقى من الوقت", ApplicationManager.instance.theme.secondaryFontColor, radius/5),
              customNText(timeUntilNextPrayer, ApplicationManager.instance.theme.secondaryFontColor, radius/5)
            ],
          ),
        )
      ],
    );
  }
  Widget customNText(String text, Color color, double fontSize){
    return Text(text, style: TextStyle(color: color, fontSize: fontSize), maxLines: 1);
  }
  Widget customText(String text, Color color, double fontSize){
    return AutoSizeText(text, style: TextStyle(color: color, fontSize: fontSize), maxLines: 1);
  }
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String threeDigitMinutes = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$threeDigitMinutes";
  }
}