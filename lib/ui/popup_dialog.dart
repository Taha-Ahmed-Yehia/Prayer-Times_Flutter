import 'package:flutter/material.dart';
import 'package:prayer_times/manager/application_manager.dart';
import '../global/navigator_key.dart';

class PopupDialog {
  static showPopupDialog(String title, String dialog){
    final context = mainNavigatorKey.currentContext;
    if(context != null){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: ApplicationManager.instance.theme.secondaryBackgroundColor,
            title: Text(title, style: TextStyle(color: ApplicationManager.instance.theme.primaryFontColor)),
            content: Text(dialog, style: TextStyle(color: ApplicationManager.instance.theme.primaryFontColor)),
            actions: [
              TextButton(onPressed: ()=> Navigator.pop(context, true), child: Text("Ok", style: TextStyle(color: ApplicationManager.instance.theme.primaryFontColor)))
            ],
          )
      );
    }
  }
  static showPopupDialogWithButton(String title, String dialog, String buttonTitle,Function buttonAction){
    final context = mainNavigatorKey.currentContext;
    if(context != null){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: ApplicationManager.instance.theme.secondaryBackgroundColor,
            title: Text(title, style: TextStyle(color: ApplicationManager.instance.theme.primaryFontColor)),
            content: Text(dialog, style: TextStyle(color: ApplicationManager.instance.theme.primaryFontColor)),
            actions: [
              TextButton(onPressed: (){
                buttonAction.call();
                Navigator.pop(context, true);
              },
                  child: Text(buttonTitle, style: TextStyle(color: ApplicationManager.instance.theme.primaryFontColor)))
            ],
          )
      );
    }
  }
}