import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data/app_theme_data.dart';
import '../Data/size_config.dart';
import '../Models/app_theme.dart';
import '../Widgets/General/back_to_prev_screen_button.dart';
import '../Widgets/Specific/Color Picker/color_pick_widget.dart';
import '../Widgets/General/custom_text_field.dart';

// ignore: must_be_immutable
class CreateOrEditTheme extends StatelessWidget {
  final AppTheme mainTheme;
  final bool editing;
  late AppTheme theme;
  CreateOrEditTheme(this.mainTheme, {this.editing = false, Key? key}) : super(key: key) {
    theme = mainTheme.clone();
    if(!editing){
      theme.name = "New Theme";
    }
    theme.isDefault = false;
  }

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig.instanse;
    return Consumer<AppThemeData>(
        builder: (context, appThemeData, child){
          return SafeArea(
            child: Scaffold(
              backgroundColor: appThemeData.selectedTheme.primaryColor,
              body: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _topBar(appThemeData, sizeConfig),
                      Padding(
                        padding: EdgeInsets.all(20 * sizeConfig.safeBlockSmallest),
                        child: Column(
                          children: [
                            CustomTextField(sizeConfig, appThemeData, maxLength: 0, onChanged: (value){theme.name = value;}, hintText: "Enter theme name...", text: editing ? theme.name:""),
                            SizedBox(height: 10 * sizeConfig.safeBlockSmallest,),
                            ColorPick("Primary Color:", theme.primaryColor, appThemeData.selectedTheme,onSelectFunction: (value){theme.primaryColor = value;}),
                            SizedBox(height: 5 * sizeConfig.safeBlockSmallest,),
                            ColorPick("Primary Light Color:", theme.primaryLightColor, appThemeData.selectedTheme, onSelectFunction: (value){theme.primaryLightColor = value;}),
                            SizedBox(height: 5 * sizeConfig.safeBlockSmallest,),
                            ColorPick("Primary Dark Color:", theme.primaryDarkColor, appThemeData.selectedTheme, onSelectFunction: (value){theme.primaryDarkColor = value;}),
                            SizedBox(height: 5 * sizeConfig.safeBlockSmallest,),
                            ColorPick("Secondary Color:", theme.secondaryColor, appThemeData.selectedTheme, onSelectFunction: (value){theme.secondaryColor = value;}),
                            SizedBox(height: 5 * sizeConfig.safeBlockSmallest,),
                            ColorPick("Text Color:", theme.textColor, appThemeData.selectedTheme, onSelectFunction: (value){theme.textColor = value;}),
                            SizedBox(height: 5 * sizeConfig.safeBlockSmallest,),
                            ColorPick("Secondary Text Color:", theme.textDarkColor, appThemeData.selectedTheme, onSelectFunction: (value){theme.textDarkColor = value;})
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: sizeConfig.screenWidth,
                      padding: EdgeInsetsDirectional.all(10 * sizeConfig.safeBlockSmallest),
                      child: ElevatedButton(
                        onPressed: (){
                          //create theme
                          if(!editing){
                            appThemeData.addTheme(theme);
                          }else{
                            appThemeData.editTheme(mainTheme.id, theme);
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                            elevation: 1
                        ),
                        child: Text(
                            editing ? "Done" : "Add",
                            style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 24 * sizeConfig.safeBlockSmallest)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Row _topBar(AppThemeData appThemeData, SizeConfig sizeConfig) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackToPrevScreenButton(appThemeData.selectedTheme.textColor, buttonSize: 30 * sizeConfig.safeBlockSmallest),
        Text(
            editing ? "Edit Theme" : "Create Theme",
            textAlign: TextAlign.center,
            style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 30 * sizeConfig.safeBlockSmallest, fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                      blurRadius: 2,
                      color: appThemeData.selectedTheme.secondaryColor.withAlpha(128),
                      offset: const Offset(2, 2)
                  )
                ]
            )
        ),
        SizedBox(width: 30 * sizeConfig.safeBlockSmallest,)
      ],
    );
  }
}
