import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  late EdgeInsets safeAreaBounds;
  late double screenWidth;
  late double screenHeight;

  late double blockSizeHorizontal;
  late double blockSizeVertical;

  late double safeBlockHorizontal;
  late double safeBlockVertical;

  late double safeAspectRatio;
  late double aspectRatio;

  late double safeBlockSmallest;
  late double blockSmallest;

  late Size autoScale;
  late Size safeAutoScale;

  late Size screenSizeRef;
  SizeConfig(BuildContext context, {Size screenSizeReference = const Size(640, 360)}) {
    _mediaQueryData = MediaQuery.of(context);

    if(_mediaQueryData.orientation == Orientation.portrait){
      screenSizeRef = Size(screenSizeReference.height, screenSizeReference.width);
    }else{
      screenSizeRef = screenSizeReference;
    }

    screenWidth = _mediaQueryData.size.width ;
    screenHeight = _mediaQueryData.size.height;

    blockSizeHorizontal = screenWidth / screenSizeRef.width;
    blockSizeVertical = screenHeight / screenSizeRef.height;

    safeAreaBounds = _mediaQueryData.padding;

    var safeAreaHorizontal = safeAreaBounds.left + safeAreaBounds.right;
    var safeAreaVertical = safeAreaBounds.top + safeAreaBounds.bottom;

    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / screenSizeRef.width;
    safeBlockVertical = (screenHeight - safeAreaVertical) / screenSizeRef.height;


    autoScale = Size(screenWidth / screenSizeRef.width, screenHeight / screenSizeRef.height);
    safeAutoScale = Size(safeAreaHorizontal / screenSizeRef.width, safeAreaVertical / screenSizeRef.height);

    aspectRatio = min(autoScale.width, autoScale.height) / max(autoScale.width, autoScale.height);
    safeAspectRatio = min(safeAutoScale.width, safeAutoScale.height) / max(safeAutoScale.width, safeAutoScale.height);

    blockSmallest = min(blockSizeVertical, blockSizeHorizontal);
    safeBlockSmallest = min(safeBlockVertical, safeBlockHorizontal);

    if (kDebugMode) {
      print("${_mediaQueryData.size}, [$screenWidth, $screenHeight], [$autoScale]");
    }
  }
}