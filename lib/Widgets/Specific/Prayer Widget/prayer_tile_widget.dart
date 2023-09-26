
import 'package:flutter/material.dart';
import '/Data/size_config.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../Data/app_theme_data.dart';

class PrayerTile extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final IconData prayerIcon;
  const PrayerTile({Key? key, required this.prayerName, required this.prayerTime, required this.prayerIcon,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig.instanse;
    var iconSize = 18 * sizeConfig.blockSmallest;
    var fontSize =  18 * sizeConfig.blockSmallest;
    return Consumer<AppThemeData>(
      builder: (context, appThemeData, child) => Container(
        width: sizeConfig.screenWidth * .9,
        height: 50 * sizeConfig.blockSizeVertical,
        decoration: BoxDecoration(
          color: appThemeData.selectedTheme.secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(25 * sizeConfig.blockSmallest)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16 * sizeConfig.blockSmallest),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(prayerIcon, color: appThemeData.selectedTheme.textDarkColor, size: iconSize,),
            Text(prayerName, style: TextStyle(fontSize: fontSize, color: appThemeData.selectedTheme.textDarkColor, ), textAlign: TextAlign.center),
            Text(prayerTime, style: TextStyle(fontSize: fontSize, color: appThemeData.selectedTheme.textDarkColor), textAlign: TextAlign.center),
            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.bell, color: appThemeData.selectedTheme.textDarkColor, size: iconSize,))
          ],
        ),
      ),
    );
  }


}
