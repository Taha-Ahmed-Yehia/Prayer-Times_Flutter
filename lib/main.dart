import 'package:flutter/material.dart';
import 'package:prayer_times/global/constants.dart';
import 'main_screen.dart';
import 'global/navigator_key.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        navigatorKey: mainNavigatorKey,
        home: const MainScreen()
    );
  }
}