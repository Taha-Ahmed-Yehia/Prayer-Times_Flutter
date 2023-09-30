import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/Data/PrayerTimesData.dart';
import '/Data/size_config.dart';
import '/Screens/settings_screen.dart';
import '/Screens/theme_picker_screen.dart';
import '/Widgets/Specific/Menu/custom_menu_button.dart';

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({
    super.key,
    required this.preyerTimesData,
    required this.sizeConfig
  });

  final PrayerTimesData preyerTimesData;
  final SizeConfig sizeConfig;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          iconSize: 24 * sizeConfig.textScaleFactor,
          icon: FontAwesomeIcons.bars,
        )
      ),
    );
  }
}