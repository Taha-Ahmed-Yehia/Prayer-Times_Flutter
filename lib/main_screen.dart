import 'package:flutter/material.dart';
import 'package:prayer_times/responsive/mobile_layout.dart';
import 'package:prayer_times/responsive/responsive_layout.dart';
import 'package:prayer_times/responsive/tablet_layout.dart';
import 'package:prayer_times/ui/loading_screen.dart';
import 'manager/application_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState(){
    ApplicationManager.instance.init();
    if(!ApplicationManager.instance.mainScreenRebuildRequest.containAction(refresh)){
      ApplicationManager.instance.mainScreenRebuildRequest.addAction(refresh);
    }
  }
  refresh(){
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      setState(() {
        print("main_screen: refreshed");
      });
    }));
  }
  @override
  void dispose() {
    ApplicationManager.instance.mainScreenRebuildRequest.removeAction(refresh);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return !ApplicationManager.instance.isInitialized ?
    loadingScreen() :
    appWidget();
  }
  Widget appWidget(){
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: ResponsiveLayout(tablet: TabletLayout(), mobile:  MobileLayout())
    );
  }
}