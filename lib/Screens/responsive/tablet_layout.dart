import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/app_theme_data.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeData>(
      builder: (context, appThemeData, child) => Container(color: appThemeData.selectedTheme.primaryColor),
    );
  }
}