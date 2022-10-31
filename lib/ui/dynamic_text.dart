

import 'package:flutter/material.dart';

class DynamicSizeText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final double minimumFontScale;
  final TextOverflow textOverflow;
  const DynamicSizeText(this.text,
      {required this.style,
        this.textAlign = TextAlign.left,
        this.textDirection = TextDirection.ltr,
        this.minimumFontScale = 0.5,
        this.textOverflow = TextOverflow.ellipsis,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextPainter painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: textAlign,
        textScaleFactor: 1,
        maxLines: 100,
        textDirection: textDirection);

    return LayoutBuilder(
      builder: (context, constraints) {
        painter.layout(maxWidth: constraints.maxWidth);
        double textScaleFactor = 1;

        if (painter.height > constraints.maxHeight) { //
          print('${painter.size}');
          painter.textScaleFactor  = minimumFontScale;
          painter.layout(maxWidth: constraints.maxWidth);
          print('${painter.size}');

          if (painter.height > constraints.maxHeight) { //
            //even minimum does not fit render it with minimum size
            print("Using minimum set font");
            textScaleFactor = minimumFontScale;
          } else if (minimumFontScale < 1) {
            //binary search for valid Scale factor
            int h = 100; //why 100, strpping 0.01 scale factor to get exact fit value
            int l =   (minimumFontScale * 100).toInt();
            while (h > l) {
              int mid = (l + (h - l) / 2).toInt();
              double newScale = mid.toDouble()/100.0;
              painter.textScaleFactor  = newScale;
              painter.layout(maxWidth: constraints.maxWidth);

              if (painter.height > constraints.maxHeight) { //
                h = mid - 1;
              } else {
                l = mid + 1;
              }
              if  (h <= l) {
                print('${painter.size}');
                textScaleFactor = newScale - 0.01;
                painter.textScaleFactor  = newScale;
                painter.layout(maxWidth: constraints.maxWidth);
                break;
              }


            }
          }
        }

        return Text(
          text,
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: 100,
          overflow: textOverflow,
        );
      },
    );
  }
}