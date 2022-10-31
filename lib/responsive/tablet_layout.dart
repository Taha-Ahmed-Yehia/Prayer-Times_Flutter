import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prayer_times/manager/application_manager.dart';
import 'package:prayer_times/manager/prayer_times_helper.dart';
import 'package:prayer_times/global/static_methods.dart';
import 'package:prayer_times/ui/outline_boarder.dart';
import '../ui/dynamic_text.dart';
import '../ui/next_prayer_widget.dart';
import '../ui/time_widget.dart';

class TabletLayout extends StatefulWidget {
  const TabletLayout({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TabletLayout();
}

class _TabletLayout extends State<TabletLayout>{
  final ScrollController verticalController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        /*appBar: AppBar(
            backgroundColor: ApplicationManager.instance.theme.primaryBackgroundColor,
            title: Row(
                children: [
                  const Image(image: AssetImage("assets/icons/app_icon.png"), width: 20,height: 20,),
                  _gradientText(const DynamicSizeText("   $appTitle", style: TextStyle(fontSize: 18)), LinearGradient(colors: [hexColor("cf5e02"),hexColor("f4b028")], stops: const [0.25, 1]))
                ]
            )
        ),*/
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
        child: Row(
          mainAxisAlignment:  size.height < 550? MainAxisAlignment.start:MainAxisAlignment.center,
          crossAxisAlignment: size.height < 550? CrossAxisAlignment.start:CrossAxisAlignment.center,
          children: [
            leftPanel(size),
            rightPanel(size)
          ]
        ),
        onTapUp: (_) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
        },
      )
    );
  }
  //next prayer widget
  Widget rightPanel(Size size) {
    if(size.height < 550){
      return Expanded(child: Padding(padding: const EdgeInsets.all(15), child: NextPrayerWidget()));
    }
    return Expanded(child: NextPrayerWidget());
  }
  //date and prayer times widget
  Widget leftPanel(Size size){
    final theme = ApplicationManager.instance.theme;
    double height = size.height.clamp(550, double.infinity);
    return Container(
      width: 250,
      height: height,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.secondaryColor,
            theme.primaryBackgroundColor,
            theme.primaryBackgroundColor,
            theme.secondaryColor,
          ],
          stops: const [0,.05, .95, 1]
        )
      ),

      child: Column(
        children: [
          const TimeWidget(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: showPrayerTiles()
          )
        ]
      ),
    );
  }

  List<Widget> showPrayerTiles(){
    PrayerTimesHelper prayers = ApplicationManager.instance.prayerTimes;
    List<Widget> tiles = List.empty(growable: true);
    for(int i = 1; i < 7; i++){
      tiles.add(const Divider(height: 20));
      tiles.add(prayerTile(prayers.getPrayer(i)));
    }
    return tiles;
  }
  Widget prayerTile(PrayerData prayer){
    final theme = ApplicationManager.instance.theme;
    return OutlineContainer(
      theme.primaryBackgroundColor,
      LinearGradient(
          colors: [
            theme.primaryColor,
            theme.secondaryColor,
            theme.secondaryColor,
            theme.primaryColor
          ],
          stops: const [0, .25, .75, 1]
      ),
      boarderWidth: 1,
      padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _gradientText(
            DynamicSizeText(prayer.prayer.name, style: const TextStyle(fontSize: 32)),
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [theme.primaryFontColor, theme.secondaryFontColor],
              stops: const [0.25, 1]
            )
          ),
          _gradientText(
            DynamicSizeText(
                dateFormatToTime(prayer.prayerDatTime),
                style: const TextStyle(fontSize: 18)
            ),
            LinearGradient(
                colors: [theme.primaryFontColor, theme.secondaryFontColor],
                stops: const [0, 1]
            )
          ),
        ]
      )
    );
  }

  Widget _gradientText(DynamicSizeText text, Gradient gradient){
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: text,
    );
  }
}