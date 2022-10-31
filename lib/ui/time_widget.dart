import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prayer_times/ui/outline_boarder.dart';
import '../manager/application_manager.dart';
import '../global/constants.dart';
import '../responsive/responsive_layout.dart';
import '../global/static_methods.dart';
import 'dynamic_text.dart';

class TimeWidget extends StatefulWidget{
  const TimeWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TimeWidget();
  }
}

class _TimeWidget extends State<TimeWidget>{
  Timer? timer;
  bool isMobile = false;
  DateTime time = DateTime.now();
  _TimeWidget(){
    isMobile = ResponsiveLayout.isMobile;
    int delay = 60 - DateTime.now().second;
    Timer(Duration(seconds: delay + 1), ()=> setState((){}));
    timer = Timer.periodic(const Duration(minutes: 1), (_)=> setState((){}));
  }
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
  String _getTimeHM(){
    return dateFormatToTime(time);
  }
  @override
  Widget build(BuildContext context) {
    //refresh time on build
    time = DateTime.now();
    double minFontSize = 24;
    return OutlineContainer(
        ApplicationManager.instance.theme.primaryBackgroundColor,
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ApplicationManager.instance.theme.primaryColor,
            ApplicationManager.instance.theme.secondaryColor,
            ApplicationManager.instance.theme.primaryColor,
            ApplicationManager.instance.theme.secondaryColor,
            ApplicationManager.instance.theme.primaryColor,
            ApplicationManager.instance.theme.secondaryColor,
            ApplicationManager.instance.theme.primaryColor,
          ],
          stops: const [0, .1, .3, .5, .65,.8, 1]
        ),
        boarderWidth: 2,
        borderRadius: 8,
        isMobile ? dateMobileWidget(minFontSize) : dateTabletWidget(minFontSize)
    );
  }
  Widget dateTabletWidget(double minFontSize){
    return Container(
      height: 100,
      width: 250,
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _gradientIcon(
                calendarToday,
                LinearGradient(
                    colors: [
                      ApplicationManager.instance.theme.primaryColor, ApplicationManager.instance.theme.secondaryColor],
                    stops: const [0.1,.5], begin: Alignment.topCenter, end: Alignment.bottomCenter
                )
              ),
              _gradientIcon(
                Icons.access_time_rounded,
                LinearGradient(
                      colors: [
                        ApplicationManager.instance.theme.primaryColor, ApplicationManager.instance.theme.secondaryColor],
                      stops: const [0.1,.5], begin: Alignment.topCenter, end: Alignment.bottomCenter
                  )
              )
            ]
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DynamicSizeText("  ${_getTimeHM()}", style: TextStyle(color: ApplicationManager.instance.theme.secondaryFontColor, fontSize: minFontSize)),
              DynamicSizeText("  ${_getDate()}", style: TextStyle(color: ApplicationManager.instance.theme.secondaryFontColor, fontSize: minFontSize))
            ]
          )
        ]
      )
    );
  }
  Widget dateMobileWidget(double minFontSize){
    return Container(
      height: 30,
      padding: const EdgeInsets.all(2),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _gradientIcon(
                calendarToday,
                LinearGradient(
                    colors: [
                      ApplicationManager.instance.theme.primaryColor, ApplicationManager.instance.theme.secondaryColor],
                    stops: const [0.1,.5], begin: Alignment.topCenter, end: Alignment.bottomCenter
                )
            ),
            DynamicSizeText("  ${_getDate()}", style: TextStyle(color: ApplicationManager.instance.theme.secondaryFontColor, fontSize: minFontSize)),
            const SizedBox(width: 50),
            _gradientIcon(
                Icons.access_time_rounded,
                LinearGradient(
                    colors: [
                      ApplicationManager.instance.theme.primaryColor, ApplicationManager.instance.theme.secondaryColor],
                    stops: const [0.1,.5], begin: Alignment.topCenter, end: Alignment.bottomCenter
                )
            ),
            DynamicSizeText("  ${_getTimeHM()}", style: TextStyle(color: ApplicationManager.instance.theme.secondaryFontColor, fontSize: minFontSize))
          ]
      ),
    );
  }
  String _getDate() {
    return "${time.day}\\${time.month}\\${time.year}";
  }
  _gradientIcon(IconData iconData, Gradient gradient) {
    return ShaderMask(blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height)
        ),
        child: Icon(iconData)
    );
  }
}
