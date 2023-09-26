// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Data/app_theme_data.dart';
// import '../Data/notification_api.dart';
import '../Data/PrayerTimesData.dart';
import '../Data/constants.dart';
import 'package:provider/provider.dart';
import 'Screens/responsive/mobile_layout.dart';
import 'Screens/responsive/responsive_layout.dart';
import 'Screens/responsive/tablet_layout.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent
      )
  );

  tz.initializeTimeZones();

  //NotificationAPI.initNotification();
  runApp(const MyApp());
  // runApp(
  //   kDebugMode ? 
  //   DevicePreview(
  //     isToolbarVisible: true,
  //     builder: (context) => const MyApp(),
  //   ) :
  //   const MyApp()
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppThemeData>(
      create: (context) => AppThemeData(),
      child: ChangeNotifierProvider<PrayerTimesData>(
        create: (context) => PrayerTimesData(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: appTitle,
            navigatorKey: mainNavigatorKey,
            // locale: DevicePreview.locale(context),
            // builder: DevicePreview.appBuilder,
            home: const Scaffold(
              resizeToAvoidBottomInset: false,
              body: ResponsiveLayout(tablet: TabletLayout(), mobile:  MobileLayout())
            )
        ),
      ),
    );
  }
}