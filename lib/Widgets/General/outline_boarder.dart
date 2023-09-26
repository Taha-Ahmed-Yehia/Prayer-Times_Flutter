
import 'package:flutter/material.dart';

class OutlineContainer extends StatelessWidget {
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Gradient gradient;
  final Color backgroundColor;
  final Widget child;

  const OutlineContainer(this.backgroundColor, this.gradient, this.child, {this.borderWidth = 1, this.borderRadius = 1,  this.padding = const EdgeInsets.all(1), Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final kInnerDecoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
    );
    final kGradientBoxDecoration = BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
    );

    return Container(
      decoration: kGradientBoxDecoration,
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        padding: padding,
        decoration: kInnerDecoration,
        child: child
      ),
    );
  }
}