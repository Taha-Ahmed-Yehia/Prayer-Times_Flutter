
import 'package:flutter/material.dart';
import '../Data/app_theme_data.dart';
import '../Data/constants.dart';
import '../Data/size_config.dart';
import 'package:provider/provider.dart';

void showCustomDialog(String title, String message){
  var context = mainNavigatorKey.currentContext!;
  showDialog(context: context,
      builder: (context) => Consumer<AppThemeData>(
        builder: (context, appThemeData, child) => AlertDialog(
          backgroundColor: appThemeData.selectedTheme.primaryColor,
          title: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: appThemeData.selectedTheme.textColor,
                  fontSize: 32 * SizeConfig.instanse.textScaleFactor,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          content: FittedBox(
            child: Text(
              message,
              style: TextStyle(
                  color: appThemeData.selectedTheme.textColor,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      )
  );
}
