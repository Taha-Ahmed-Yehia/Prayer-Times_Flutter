
import 'package:flutter/material.dart';

class BackToPrevScreenButton extends StatelessWidget {
  final Color iconColor;
  final double buttonSize;
  const BackToPrevScreenButton(this.iconColor,{
    this.buttonSize = 50,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_rounded),
      color: iconColor,
      iconSize: buttonSize,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}