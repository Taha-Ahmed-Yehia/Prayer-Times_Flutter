import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prayer_times/manager/application_manager.dart';
import 'package:prayer_times/global/constants.dart';
import 'package:prayer_times/manager/prayer_times_helper.dart';
import 'package:prayer_times/global/static_methods.dart';
import 'package:prayer_times/global/theme_data.dart';
import '../ui/next_prayer_widget.dart';
import '../ui/time_widget.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MobileLayout();
}

class _MobileLayout extends State<MobileLayout> {
  final ScrollController verticalController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ApplicationManager.instance.theme.primaryBackgroundColor,
            title: Row(
                children: [
                  const Image(image: AssetImage("assets/icons/app_icon.png"), width: 20,height: 20,),
                  _gradientText(const Text("   $appTitle"), LinearGradient(colors: [hexColor("cf5e02"),hexColor("f4b028")], stops: const [0.25, 1]))
                ]
            )
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: ApplicationManager.instance.theme.primaryBackgroundColor,
        body: mainPanel(size)
    );
  }
  Widget mainPanel(Size size){
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: verticalController,
        reverse: false,
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //top panel that contains current Date and Time widget and next prayer widget
            topPanel(size),
            const Divider(height: 20),
            //bottom panel that show all prayers times
            bottomPanel(),
          ]
        ),
        onTapUp: (_) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
        },
      )
    );
  }
  Widget topPanel(Size size) {
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: Container(
            height: 300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ApplicationManager.instance.theme.primaryBackgroundColor,ApplicationManager.instance.theme.secondaryBackgroundColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.25, 1]
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                const TimeWidget(),
                NextPrayerWidget(height: 250),
              ],
            )
        )
      );
    },
    );
  }
  Widget bottomPanel(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: showPrayerTiles(),
    );
  }

  List<Widget> showPrayerTiles(){
      PrayerTimesHelper prayers = ApplicationManager.instance.prayerTimes;
      List<Widget> tiles = List.empty(growable: true);
      for(int i = 1; i < 7; i++){
          tiles.add(prayerTile(prayers.getPrayer(i)));
      }
      return tiles;
  }
  Widget prayerTile(PrayerData prayer){
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width - 15,
        height: 50,
        margin: const EdgeInsets.only(left: 15,right: 15,bottom: 5),
        decoration: BoxDecoration(
            color: Colors.amber,
            gradient: LinearGradient(colors: [hexColor("ffcf5e02"), hexColor("ff5b1707"), hexColor("ff5b1707"), hexColor("ffcf5e02")], stops: const [0, .1, .9,1]),
            borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: Container(
            margin: const EdgeInsets.only(top: 2,left: 2,bottom: 2,right: 2),
            decoration: BoxDecoration(
              color: ApplicationManager.instance.theme.primaryBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: _gradientText(
                            Text(prayer.prayer.name, style: const TextStyle(fontSize: 24)),
                            LinearGradient(
                                colors: [ApplicationManager.instance.theme.primaryFontColor, ApplicationManager.instance.theme.secondaryFontColor],
                                stops: const [0,.5]
                            )
                        )
                    )
                ),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child:_gradientText(
                                Text(
                                    dateFormatToTime(prayer.prayerDatTime),
                                    style: const TextStyle(fontSize: 18)
                                ),
                                LinearGradient(
                                    colors: [ApplicationManager.instance.theme.primaryFontColor, ApplicationManager.instance.theme.secondaryFontColor],
                                    stops: const [0, 1])
                            )
                        )
                      ],
                    )
                )
              ]
          ),
        )
    );
  }
  Widget _gradientText(Text text, Gradient gradient){
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: text,
    );
  }
}
