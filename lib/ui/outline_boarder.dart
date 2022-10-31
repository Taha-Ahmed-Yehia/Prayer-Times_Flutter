
import 'package:flutter/material.dart';

class OutlineContainer extends StatelessWidget {
  late double _borderWidth;
  late double _borderRadius;
  late EdgeInsetsGeometry _padding;
  final Gradient gradient;
  final Color backgroundColor;
  final Widget child;

  OutlineContainer(this.backgroundColor, this.gradient, this.child, {double? boarderWidth, double?borderRadius, EdgeInsetsGeometry?padding, Key? key}) : super(key: key) {
    _borderWidth = boarderWidth ?? 1;
    _borderRadius = borderRadius ?? 1;
    _padding = padding ?? const EdgeInsets.all(1);
  }
  @override
  Widget build(BuildContext context) {
    final kInnerDecoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(_borderRadius),
    );
    final kGradientBoxDecoration = BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(_borderRadius),
    );

    return Container(
      decoration: kGradientBoxDecoration,
      child: Container(
        margin: EdgeInsets.all(_borderWidth),
        padding: _padding,
        decoration: kInnerDecoration,
        child: child
      ),
    );
  }
}