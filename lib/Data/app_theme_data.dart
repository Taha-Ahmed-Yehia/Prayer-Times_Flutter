
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Data/constants.dart';
import '../Extensions/hex_color_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/app_theme.dart';

class AppThemeData extends ChangeNotifier{
  List<AppTheme> themes = [

  ];
  final List<AppTheme> defaultThemes = [
    AppTheme(
      name:"Chery",
      primaryColor: "f25477".toColor(),
      primaryLightColor: "ffa7a6".toColor(),
      primaryDarkColor: "ec275f".toColor(),
      secondaryColor: "ffdcdc".toColor(),
      textColor: Colors.white,
      textDarkColor: Colors.black,
      isDefault: true
    ),
    AppTheme(
      name: "Coffee",
      primaryColor: "CEAB93".toColor(),
      primaryLightColor: "E3CAA5".toColor(),
      primaryDarkColor: "AD8B73".toColor(),
      secondaryColor: "FFFBE9".toColor(),
      textColor: Colors.black,
      textDarkColor:Colors.black,
      isDefault: true
    ),
    AppTheme(
      name:"Dark",
      primaryColor: "474E68".toColor(),
      primaryLightColor: "50577A".toColor(),
      primaryDarkColor: "404258".toColor(),
      secondaryColor: "6B728E".toColor(),
      textColor: Colors.white,
      textDarkColor: Colors.black,
      isDefault: true
    ),
    AppTheme(
      name:"Leaf",
      primaryColor:"CCD6A6".toColor(),
      primaryLightColor:"E9EDC9".toColor(),
      primaryDarkColor:"acbb7c".toColor(),
      secondaryColor:"FEFAE0".toColor(),
      textColor:Colors.black87,
      textDarkColor: Colors.black,
      isDefault: true
    ),
    AppTheme(
      name: "The Old 1",
      primaryColor:"666666".toColor(),
      primaryLightColor:"999999".toColor(),
      primaryDarkColor:"333333".toColor(),
      secondaryColor:"ffd3d3d3".toColor(),
      textColor:Colors.white,
      textDarkColor:Colors.black,
      isDefault: true
    ),
    AppTheme(
      name: "Clay",
      primaryColor:"4F4557".toColor(),
      primaryLightColor:"6D5D6E".toColor(),
      primaryDarkColor:"393646".toColor(),
      secondaryColor:"c8b09c".toColor(),
      textColor: Colors.white,
      textDarkColor: Colors.black,
      isDefault: true
    )
  ];
  List<AppTheme> userThemes = [];

  late AppTheme selectedTheme;
  int selectedThemeID = 0;


  AppThemeData(){
    loadMain();
    load();
  }

  void loadMain(){
    themes.addAll(defaultThemes);
    selectedTheme = themes[selectedThemeID];
    notifyListeners();
  }
  void load() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    //sharedPreferences.clear();
    var data = sharedPreferences.getString(appThemeDataSaveKey);
    //print(data);
    if(data != null){
      if(data.isNotEmpty){
        try{
          var themeJson = AppThemeModel.fromJson(jsonDecode(data));
          if(themeJson.themes != []){
            userThemes = themeJson.themes;
            themes.addAll(userThemes);
            selectedTheme = themes[themeJson.selectedThemeID];
          }
        }catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }
    notifyListeners();
  }
  void save() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    var appThemeModel = AppThemeModel(userThemes, selectedThemeID);
    var pref = jsonEncode(appThemeModel);
    sharedPreferences.setString(appThemeDataSaveKey, pref);
  }

  void addTheme(AppTheme theme){
    var nameClone = 0;
    for(var item in themes){
      if(item.name == theme.name){
        nameClone++;
      }
    }
    if(nameClone > 0){
      theme.name += " $nameClone";
    }
    selectedTheme = theme;
    selectedThemeID = themes.length - 1;
    themes.add(theme);
    userThemes.add(theme);
    notifyListeners();
    save();
  }
  void removeTheme(AppTheme theme){
    if(selectedTheme == theme) {
      selectedThemeID = 0;
      selectedTheme = defaultThemes[0];
    }
    themes.remove(theme);
    userThemes.remove(theme);
    notifyListeners();
    save();
  }

  void selectTheme(int id){
    selectedTheme = themes[id];
    selectedThemeID = id;
    notifyListeners();
    save();
  }

  void editTheme(int themeID, AppTheme theme2) {
    for(int i = 0; i < themes.length; i++){
      if(themes[i].id == themeID){
        themes[i] = theme2;
        selectedTheme = theme2;
        selectedThemeID = i;
        //print("Found Theme ${themes[i].name} with ID[$themeID] with index[$i] in themes");
        break;
      }
    }

    for(int i = 0; i < userThemes.length; i++){
      if(userThemes[i].id == themeID){
        userThemes[i] = theme2;
        //print("Found Theme ${userThemes[i].name} with ID[$themeID] with index[$i] in userThemes");
        break;
      }
    }

    notifyListeners();
    save();
  }

}

class AppThemeModel {
  List<AppTheme> themes = [];
  int selectedThemeID;

  AppThemeModel(this.themes, this.selectedThemeID);

  factory AppThemeModel.fromJson(Map<String,dynamic> json) => AppThemeModel(
    json['themes'] == null ? [] : List<AppTheme>.from(jsonDecode(json['themes']).map((model)=> AppTheme.fromJson(model))),
    json['selectedThemeID'],
  );

  Map<String,dynamic> toJson() => {
    "themes": json.encode(themes),
    'selectedThemeID': selectedThemeID
  };
}