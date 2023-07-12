
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data/size_config.dart';
import '../Models/app_theme.dart';

// ignore: must_be_immutable
class CustomColorPickTextField extends StatelessWidget {
  final String title;
  final String text;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final AppTheme theme;
  final Size size;
  final TextInputType inputType;
  final double fontSize;

  late TextEditingController controller;

  CustomColorPickTextField(this.title, this.text, this.theme,
  {this.onSubmitted, this.onTapOutside, this.size = const Size(100, 50), this.inputType = TextInputType.number, this.fontSize = 18, super.key}) {
    controller = TextEditingController(text: text);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig(context);
    TextStyle textStyle = TextStyle(color: theme.textColor, fontSize: fontSize * sizeConfig.safeBlockSmallest);
    return ChangeNotifierProvider(
      create: (context) => CustomColorPickerTextInputValue(),
      child: Consumer<CustomColorPickerTextInputValue>(
        builder: (context, selected, child) => GestureDetector(
          onTap: () {
            controller.selection = TextSelection(baseOffset: 0, extentOffset: text.length);
            selected.select();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: textStyle, textAlign: TextAlign.start,),
              SizedBox(width: 5 * sizeConfig.safeBlockSmallest),
              Container(
                decoration: BoxDecoration(
                    color: theme.primaryLightColor,
                    borderRadius: BorderRadius.circular(10 * sizeConfig.safeBlockSmallest),
                    boxShadow: [
                      BoxShadow(
                          color: theme.primaryColor,
                          blurRadius: 2,
                          offset: const Offset(0,1)
                      ),
                    ]
                ),
                padding: EdgeInsetsDirectional.all(5 * sizeConfig.safeBlockSmallest),
                width: size.width * sizeConfig.safeBlockSmallest,
                height: size.height * sizeConfig.safeBlockSmallest,
                child: _textField(selected, sizeConfig),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(CustomColorPickerTextInputValue selected, SizeConfig sizeConfig) {
    TextStyle textStyle = TextStyle(color: theme.textColor, fontSize: fontSize * sizeConfig.safeBlockSmallest);
    Widget widget = Text(text, style:  textStyle, textAlign: TextAlign.center,);
    //print("isSelected: ${selected.isSelected}, isEditing: ${selected.isEditing}");
    if(selected.isEditing){
      widget = TextField(
        autofocus: true,
        cursorColor: theme.primaryColor,
        keyboardType: inputType,
        onChanged: (value) {
          selected.edit();
        },
        onSubmitted: (value) {
          onSubmitted?.call(value);
          selected.clear();
        },
        onTapOutside: (event) {
          onTapOutside?.call(event);
          selected.clear();
        },
        textAlign: TextAlign.center,
        style: textStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusColor: theme.secondaryColor,
          fillColor: theme.secondaryColor,
        ),
      );
    }else if (selected.isSelected){
      widget = TextField(
        controller: controller,
        autofocus: true,
        cursorColor: theme.primaryColor,
        keyboardType: inputType,
        onTap: () {
          selected.edit();
        },
        onChanged: (value) {
          selected.edit();
        },
        onTapOutside: (event) {
          onTapOutside?.call(event);
          selected.clear();
        },
        textAlign: TextAlign.center,
        style: textStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusColor: theme.secondaryColor,
          fillColor: theme.secondaryColor,
        ),

      );
    }
    return Center(child: widget);
  }
}

class CustomColorPickerTextInputValue extends ChangeNotifier{
  bool isSelected = false;
  bool isEditing = false;

  void select(){
    isSelected = true;
    refresh();
  }
  void deselect(){
    isSelected = false;
    refresh();
  }
  void edit(){
    isEditing = true;
    refresh();
  }
  void unEdit(){
    isEditing = false;
    refresh();
  }
  void clear(){
    isSelected = false;
    isEditing = false;
    notifyListeners();
  }

  void refresh(){
    notifyListeners();
  }
}
