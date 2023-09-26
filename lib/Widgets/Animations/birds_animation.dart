
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import '/Data/app_theme_data.dart';
import '/Data/size_config.dart';
import 'package:provider/provider.dart';

class BirdsAnimation extends StatefulWidget {
  final double width;
  final double height;
  const BirdsAnimation(this.width, this.height, {super.key});
  @override
  State<BirdsAnimation> createState() => _BirdsAnimationState();
}

class _BirdsAnimationState extends State<BirdsAnimation> with TickerProviderStateMixin  {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late FlutterGifController controller1, controller2, controller3, controller4;
  
  final AssetImage imageAsset = const AssetImage("assets/BF1B.gif");

  @override
  void initState() {
    if (kDebugMode) {
      print("Initialized BirdAnimation.");
    }
    fetchGif(imageAsset);
    controller1 = FlutterGifController(
      vsync: this,
      duration: const Duration(milliseconds: 100), 
      reverseDuration: const Duration(milliseconds: 100),
     );

    controller1.repeat(min: 0, max: 9, period: const Duration(milliseconds: 1000));
    
    controller2 = FlutterGifController(
      vsync: this,
      duration: const Duration(milliseconds: 100), 
      reverseDuration: const Duration(milliseconds: 100),
     );

    controller2.value = 2;

    controller2.repeat(min: 0, max: 9, period: const Duration(milliseconds: 1000));


    controller3 = FlutterGifController(
      vsync: this,
      duration: const Duration(milliseconds: 100), 
      reverseDuration: const Duration(milliseconds: 100),
     );

    controller3.value = 4;

    controller3.repeat(min: 0, max: 9, period: const Duration(milliseconds: 1000));

    
    controller4 = FlutterGifController(
      vsync: this,
      duration: const Duration(milliseconds: 100), 
      reverseDuration: const Duration(milliseconds: 100),
     );

    controller4.value = 6;

    controller4.repeat(min: 0, max: 9, period: const Duration(milliseconds: 1000));


    super.initState();
    
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation = Tween<Offset>(
      begin: const Offset(-1,0),
      end: const Offset(1, 0)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig.instanse;
    const colorAlpha = 64;
    
    return Consumer<AppThemeData>(
      builder: (context, appThemeData, child) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            SizedBox(
              width: widget.width,
              child: SlideTransition(
                position: _animation,
                child: GifImage(
                    controller: controller1,
                    image: imageAsset,
                    color: appThemeData.selectedTheme.textDarkColor.withAlpha(colorAlpha),
                    fit: BoxFit.contain,
                    width: 10 * sizeConfig.blockSmallest,
                    height: 10 * sizeConfig.blockSmallest,
                  )
              ),
            ),

            Positioned(
              left: -10 * sizeConfig.blockSizeHorizontal,
              top: 95 * sizeConfig.blockSizeVertical,
              child: SizedBox(
                width: widget.width,
                child: SlideTransition(
                  position: _animation,
                  child: GifImage(
                    controller: controller2,
                    image: imageAsset,
                    color: appThemeData.selectedTheme.textDarkColor.withAlpha(colorAlpha),
                    fit: BoxFit.contain,
                    width: 10 * sizeConfig.blockSmallest,
                    height: 10 * sizeConfig.blockSmallest,
                  )
                ),
              ),
            ),
            Positioned(
              left: -30 * sizeConfig.blockSizeHorizontal,
              top: 100 * sizeConfig.blockSizeVertical,
              child: SizedBox(
                width: widget.width,
                child: SlideTransition(
                  position: _animation,
                  child: GifImage(
                    controller: controller3,
                    image: imageAsset,
                    color: appThemeData.selectedTheme.textDarkColor.withAlpha(colorAlpha),
                    fit: BoxFit.contain,
                    width: 8 * sizeConfig.blockSmallest,
                    height: 8 * sizeConfig.blockSmallest,
                  )
                ),
              ),
            ),
            Positioned(
              left: -35 * sizeConfig.blockSizeHorizontal,
              top: 115 * sizeConfig.blockSizeVertical,
              child: SizedBox(
                width: widget.width,
                child: SlideTransition(
                  position: _animation,
                  child: GifImage(
                    controller: controller4,
                    image: imageAsset,
                    color: appThemeData.selectedTheme.textDarkColor.withAlpha(colorAlpha),
                    fit: BoxFit.contain,
                    width: 15 * sizeConfig.blockSmallest,
                    height: 15 * sizeConfig.blockSmallest,
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimationFrameTrigger extends ChangeNotifier{
  void update(){
    notifyListeners();
  }
}