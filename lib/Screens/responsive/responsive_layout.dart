
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget{
  final Widget mobile;
  final Widget tablet;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
  }) : super(key: key);

  bool _isMobile(double screenWidth) => screenWidth < 600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (_isMobile(constraints.maxWidth)) {
        return mobile;
      } else {
        return tablet;
      }
    }));
  }
}