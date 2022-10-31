
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget{
  final Widget mobile;
  final Widget tablet;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
  }) : super(key: key);

  Size _renderSize(BuildContext context) => MediaQuery.of(context).size;
  bool _isMobile(double screenWidth) => screenWidth < 600;

  static bool isMobile = false;
  static late Size screenSize;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      screenSize = _renderSize(context);
      if (_isMobile(constraints.maxWidth)) {
        isMobile = true;
        return mobile;
      } else {
        isMobile = false;
        return tablet;
      }
    }));
  }
}