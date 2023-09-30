
import 'package:flutter/material.dart';

import '../../Data/app_theme_data.dart';
import '../../Data/size_config.dart';

class CustomTextField extends StatelessWidget {
  final SizeConfig sizeConfig;
  final AppThemeData appThemeData;
  final String hintText;
  final double fontSize;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool autofocus;
  final Function(String)? onChanged;
  final int maxLength;
  final String text;

  CustomTextField(this.sizeConfig, this.appThemeData,
  {this.hintText = "", this.isPassword = false, this.keyboardType = TextInputType.text,
  this.autofocus = false, this.onChanged, this.maxLength = 0, this.text = "", this.fontSize = 18, Key? key}) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _textEditingController.text = text;
    Widget textField;
    if(maxLength != 0){
      textField = TextField(
        controller: _textEditingController,
        obscureText: isPassword,
        keyboardType: keyboardType,
        autofocus: autofocus,
        minLines: 1,
        maxLines: 6,
        maxLength: maxLength,
        cursorColor: appThemeData.selectedTheme.primaryDarkColor,
        style: TextStyle(
            color: appThemeData.selectedTheme.textDarkColor,
            fontSize: fontSize * sizeConfig.textScaleFactor
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
                color: appThemeData.selectedTheme.textDarkColor.withAlpha(175),
                fontSize: fontSize * sizeConfig.textScaleFactor
            )
        ),
        onChanged: onChanged ?? (value){},
      );
    }else{
      textField = TextField(
        controller: _textEditingController,
        obscureText: isPassword,
        keyboardType: keyboardType,
        autofocus: autofocus,
        minLines: 1,
        maxLines: 6,
        cursorColor: appThemeData.selectedTheme.primaryDarkColor,
        style: TextStyle(
            color: appThemeData.selectedTheme.textDarkColor,
            fontSize: fontSize * sizeConfig.textScaleFactor
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
                color: appThemeData.selectedTheme.textDarkColor.withAlpha(175),
                fontSize: fontSize * sizeConfig.textScaleFactor
            )
        ),
        onChanged: onChanged ?? (value){},
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5 * sizeConfig.blockSmallest),
      child: Container(
        padding: EdgeInsets.all(5 * sizeConfig.blockSmallest),
        decoration: BoxDecoration(
            color: appThemeData.selectedTheme.primaryLightColor,
            borderRadius: BorderRadius.circular(10 * sizeConfig.blockSmallest),
            boxShadow: [
              BoxShadow(
                  color: appThemeData.selectedTheme.primaryDarkColor,
                  blurRadius: 2,
                  offset: const Offset(0,1)
              ),
            ]
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10 * sizeConfig.blockSmallest, right: 10 * sizeConfig.blockSmallest),
          child: textField
        ),
      ),
    );
  }
}
