
import 'package:flutter/material.dart';
import 'package:prayer_times/Data/app_theme_data.dart';
import 'package:prayer_times/Data/constants.dart';
import 'package:prayer_times/Data/size_config.dart';
import 'package:provider/provider.dart';

void showCustomDialog(String title, String message){
  var context = mainNavigatorKey.currentContext!;
  var blockSmallest = SizeConfig(context).blockSmallest;
  showDialog(context: context,
      builder: (context) => Consumer<AppThemeData>(
        builder: (context, appThemeData, child) => AlertDialog(
          backgroundColor: appThemeData.selectedTheme.primaryColor,
          title: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: appThemeData.selectedTheme.textColor,
                  fontSize: 32 * blockSmallest,
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
