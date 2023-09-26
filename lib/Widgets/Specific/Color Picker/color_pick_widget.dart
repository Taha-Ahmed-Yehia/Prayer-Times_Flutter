// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import '/Extensions/hex_color_extension.dart';
import 'package:provider/provider.dart';

import '../../../Data/app_theme_data.dart';
import '../../../Data/size_config.dart';
import '../../../Models/app_theme.dart';
import 'custom_color_picker_text_input.dart';

class ColorPick extends StatefulWidget {
  final Color pickedColor;
  final String title;
  final double fontSize;
  final Size colorBoxSize;
  final AppTheme theme;
  final Function(Color)? onSelectFunction;
  const ColorPick(this.title, this.pickedColor, this.theme, {this.colorBoxSize = const Size(128, 32), this.fontSize = 18, this.onSelectFunction,Key? key}) : super(key: key);

  @override
  State<ColorPick> createState() => _ColorPickState();
}

//widget class
class _ColorPickState extends State<ColorPick> {
  late Color _selectedColor;
  Color _selectedSpectrumColor = colorSpectrum[0];
  bool _isPickWindowOpen = false;

  static const double _svWidgetSize = 200;
  static const Size _hueWidgetSize = Size(25, _svWidgetSize);

  OverlayEntry? entry;

  double _huePointerY = 0;
  Point<double> _svPointer = const Point(0.0, 0.0);
  double _colorOpacity = 1.0;

  static const List<Color> colorSpectrum = [
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 255, 0, 0),
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedColor = widget.pickedColor;
  }
  @override
  void dispose() {
    super.dispose();
    if(_isPickWindowOpen) {
      entry?.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig.instanse;
    var colorBoxSize = widget.colorBoxSize * sizeConfig.safeBlockSmallest;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.title, style: TextStyle(
            color: widget.theme.textColor,
            fontSize: widget.fontSize * sizeConfig.safeBlockSmallest
        ),),
        Container(
          padding: EdgeInsetsDirectional.all(1 * sizeConfig.safeBlockSmallest),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(5 * sizeConfig.safeBlockSmallest),
            color: widget.theme.textDarkColor,
          ),
          width: colorBoxSize.width,
          height: colorBoxSize.height,
          child: GestureDetector(
            onTapUp:(details){
              setState(() {
                _isPickWindowOpen = !_isPickWindowOpen;
                if(_isPickWindowOpen){
                  WidgetsBinding.instance.addPostFrameCallback((_)=> showOverlay(context, sizeConfig));
                }else{
                  entry?.remove();
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(5 * sizeConfig.safeBlockSmallest),
                color: _selectedColor,
              ),
              width: colorBoxSize.width,
              height: colorBoxSize.height,
            ),
          ),
        )
      ],
    );
  }

  void showOverlay(BuildContext context, SizeConfig sizeConfig){
    _initColorWidget(sizeConfig);
    var overlay = Overlay.of(context);
    entry = OverlayEntry(
        builder: (context) => Consumer<AppThemeData>(
          builder: (context, appThemeData, child) => Scaffold(
            backgroundColor: Colors.black54,
            body: Stack(
              children: [
                GestureDetector(
                  onTap: (){
                    entry?.remove();
                    setState((){
                      _isPickWindowOpen = !_isPickWindowOpen;
                    });
                  },
                ),
                Align(alignment: Alignment.center, child: buildOverly(sizeConfig, appThemeData))
              ],
            ),
          )
        )
    );
    overlay.insert(entry!);
  }


  Widget buildOverly(SizeConfig sizeConfig, AppThemeData appThemeData) {
    TextStyle textStyle = TextStyle(
      color: appThemeData.selectedTheme.textColor,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.0* sizeConfig.safeBlockSmallest),
        child: Container(
          decoration: BoxDecoration(
            color: appThemeData.selectedTheme.primaryDarkColor,
            borderRadius: BorderRadiusDirectional.circular(20 * sizeConfig.safeBlockSmallest)
          ),
          child: Padding(
              padding: EdgeInsets.all(20.0 * sizeConfig.safeBlockSmallest),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Color Picker", style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: widget.fontSize * 2 * sizeConfig.safeBlockSmallest),),
                    SizedBox(height: 10 * sizeConfig.safeBlockSmallest,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SVPickerWidget(sizeConfig),
                        SizedBox(width: 10 * sizeConfig.safeBlockSmallest,),
                        _hueColorSelector(sizeConfig)
                      ],
                    ),
                    Divider(height: 50 * sizeConfig.safeBlockSmallest, thickness: 2, color: appThemeData.selectedTheme.primaryColor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("Color:", style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: widget.fontSize * sizeConfig.safeBlockSmallest)),
                            SizedBox(width: 10 * sizeConfig.safeBlockSmallest,),
                            Container(
                              padding: EdgeInsetsDirectional.all(2 * sizeConfig.safeBlockSmallest),
                              width: 50 * sizeConfig.safeBlockSmallest,
                              height: 25 * sizeConfig.safeBlockSmallest,
                              color: appThemeData.selectedTheme.textColor,
                              child: Container(
                                color: _selectedColor,
                              ),
                            )
                          ],
                        ),
                        CustomColorPickTextField(
                          "Hex:" ,
                          _selectedColor.toHex(),
                          appThemeData.selectedTheme,
                          onSubmitted: (value){ _selectedColor = value.toColor(); _initColorWidget(sizeConfig); },
                          onTapOutside: (p0) => _updateSelectedColor(sizeConfig),
                          size: const Size(100, 50),
                          inputType: TextInputType.text,
                        ),
                      ],
                    ),
                    SizedBox(height: 5 * sizeConfig.safeBlockSmallest,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomColorPickTextField(
                              "R:" ,
                              _selectedColor.red.toString(),
                              appThemeData.selectedTheme,
                              onSubmitted: (value){
                                _selectedColor = _selectedColor.withRed(int.parse(value));
                                _initColorWidget(sizeConfig);
                              },
                              onTapOutside: (p0) => _updateSelectedColor(sizeConfig),
                            ),
                            SizedBox(height: 10 * sizeConfig.blockSmallest,),
                            CustomColorPickTextField(
                              "G:" ,
                              _selectedColor.green.toString(),
                              appThemeData.selectedTheme,
                              onSubmitted: (value){
                                _selectedColor = _selectedColor.withGreen(int.parse(value));
                                _initColorWidget(sizeConfig);
                              },
                              onTapOutside: (p0) {
                                _updateSelectedColor(sizeConfig);
                              },
                            ),
                            SizedBox(height: 10 * sizeConfig.blockSmallest,),
                            CustomColorPickTextField(
                              "B:" ,
                              _selectedColor.blue.toString(),
                              appThemeData.selectedTheme,
                              onSubmitted: (value){
                                _selectedColor = _selectedColor.withBlue(int.parse(value.isEmpty ? "0" : value));
                                _initColorWidget(sizeConfig);
                              },
                              onTapOutside: (p0) {
                                _updateSelectedColor(sizeConfig);
                              },
                            ),
                          ] ,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomColorPickTextField(
                              "A:" ,
                              _colorOpacity.toStringAsFixed(2),
                              appThemeData.selectedTheme,
                              onSubmitted:
                              (value){
                                _colorOpacity = double.parse(value).clamp(0.0, 1.0);
                                _updateSelectedColor(sizeConfig);
                              },
                              onTapOutside: (p0) => _updateSelectedColor(sizeConfig),
                            ),
                            SizedBox(height: 10 * sizeConfig.blockSmallest,),
                            CustomColorPickTextField(
                              "S:" ,
                              ((_svPointer.x / (_svWidgetSize * sizeConfig.blockSmallest)) * 100).toStringAsFixed(2),
                              appThemeData.selectedTheme,
                              onSubmitted: (value){
                                var s = (double.parse(value) / 100) * (_svWidgetSize * sizeConfig.blockSmallest);
                                _svPointer = Point(s, _svPointer.y);
                                _updateSelectedColor(sizeConfig);
                                },
                              onTapOutside: (p0) => _updateSelectedColor(sizeConfig),
                            ),
                            SizedBox(height: 10 * sizeConfig.blockSmallest,),
                            CustomColorPickTextField(
                              "V:" ,
                              (100 - ((_svPointer.y / (_svWidgetSize * sizeConfig.blockSmallest)) * 100)).toStringAsFixed(2),
                                appThemeData.selectedTheme,
                                onSubmitted: (value){
                                var v = (double.parse(value) / 100) * (_svWidgetSize * sizeConfig.blockSmallest);
                                _svPointer = Point(_svPointer.x, v);
                                _updateSelectedColor(sizeConfig);
                              },
                              onTapOutside: (p0) => _updateSelectedColor(sizeConfig),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 50 * sizeConfig.safeBlockSmallest, thickness: 2, color: appThemeData.selectedTheme.primaryColor),
                    ElevatedButton(
                      onPressed: () {
                        entry?.remove();
                        setState((){
                          _isPickWindowOpen = !_isPickWindowOpen;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appThemeData.selectedTheme.primaryLightColor,
                        shadowColor: appThemeData.selectedTheme.primaryColor,
                      ),
                      child: FittedBox(child: Text("Ok",style: textStyle,)),
                    )
                  ],
                ),
              )
            ),
        ),
      ),
    );
  }
  Widget customColorTextInput(
      String title, String colorValue, Function(String) onChanged, TextStyle textStyle,
      AppThemeData appThemeData, SizeConfig sizeConfig, {Size size = const Size(100, 50), TextInputType inputType = TextInputType.number}
  ) {
    //var textController = TextEditingController();
    //textController.text = colorValue;
    return Row(
      children: [
        Text(title, style: textStyle, textAlign: TextAlign.center,),
        Container(
          decoration: BoxDecoration(
            color: appThemeData.selectedTheme.primaryLightColor,
            borderRadius: BorderRadius.circular(10 * sizeConfig.blockSmallest),
            boxShadow: [
              BoxShadow(
                  color: appThemeData.selectedTheme.primaryColor,
                  blurRadius: 2,
                  offset: const Offset(0,1)
              ),
            ]
          ),
          width: size.width * sizeConfig.blockSmallest,
          height: size.height * sizeConfig.blockSmallest,
          child: TextField(
            cursorColor: appThemeData.selectedTheme.primaryColor,
            keyboardType: inputType,
            onSubmitted: (value) => onChanged.call(value),
            onTapOutside: (event) => _updateSelectedColor(sizeConfig),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget _hueColorSelector(SizeConfig sizeConfig) {
    var width = _hueWidgetSize.width * sizeConfig.blockSmallest;
    var height = _hueWidgetSize.height * sizeConfig.blockSmallest;
    var pointerHeight = 4 * sizeConfig.blockSmallest;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: colorSpectrum,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        ),

      ),
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
              top: _huePointerY - pointerHeight *.5,
              child: Container(width:width, height: pointerHeight,
                decoration: const BoxDecoration(color:Colors.white,boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black),BoxShadow(blurRadius: 2, color: Colors.black)] ),
              )
          ),
          GestureDetector(
            onHorizontalDragDown:(value)=> _colorPick(value.localPosition.dy.clamp(0, height), sizeConfig),
            onHorizontalDragStart:(value)=> _colorPick(value.localPosition.dy.clamp(0, height), sizeConfig),
            onHorizontalDragUpdate: (value)=> _colorPick(value.localPosition.dy.clamp(0, height), sizeConfig),
          )
        ]
      )
    );
  }

  Widget _SVPickerWidget(SizeConfig sizeConfig) {
    var size = _svWidgetSize * sizeConfig.blockSmallest;
    var pointerSize = 25 * sizeConfig.blockSmallest;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:  [
                Colors.white,
                _selectedSpectrumColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight
            ),
          ),
          width: size,
          height: size,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors:  [
                Colors.transparent,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),
          ),
          width: _svWidgetSize * sizeConfig.blockSmallest,
          height: _svWidgetSize * sizeConfig.blockSmallest,
          child: Stack(
            children: [
              Positioned(
                  top: _svPointer.y - (pointerSize * .5),
                  left: _svPointer.x - (pointerSize * .5),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.add,
                        size: pointerSize,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 1
                          ),
                          Shadow(
                              color: Colors.black,
                              blurRadius: 1
                          ),
                          Shadow(
                              color: Colors.black,
                              blurRadius: 1
                          )
                        ]
                      ),
                    ],
                  )
              ),
              GestureDetector(
                onHorizontalDragDown:(value)=> _colorExposer(value.localPosition, size, sizeConfig),
                onHorizontalDragStart:(value)=> _colorExposer(value.localPosition, size, sizeConfig),
                onHorizontalDragUpdate: (value)=> _colorExposer(value.localPosition, size, sizeConfig),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _colorPick(double dy, SizeConfig sizeConfig) {
    _huePointerY = dy;
    _updateSelectedColor(sizeConfig);
  }
  void _colorExposer(Offset offset,double size, SizeConfig sizeConfig) {
    _svPointer = Point(offset.dx.clamp(0, size), offset.dy.clamp(0, size));
    _updateSelectedColor(sizeConfig);
  }

  void _initColorWidget(SizeConfig sizeConfig){
    //hue and Saturation and Value are same height size so i am using _svWidgetSize to get widget size on screen
    var svWidgetSize = (_svWidgetSize * sizeConfig.blockSmallest);

    var color = _selectedColor;
    //get hsv from color
    var hsvColor = HSVColor.fromColor(color);
    // h, s, v = hue, saturation, value
    double h = 1.0 - (hsvColor.hue / 360.0);
    double s = hsvColor.saturation;
    double v = 1.0 - hsvColor.value;

    _huePointerY = h * svWidgetSize;
    _svPointer = Point(s * svWidgetSize, v * svWidgetSize);
    _colorOpacity = color.opacity;

    _selectedSpectrumColor = hsvColor.withSaturation(1).withValue(1).toColor();
    _updateEntryWidget();
  }

  void _updateSelectedColor(SizeConfig sizeConfig){
    // h, s, v = hue, saturation, value
    double h,s,v;
    var h_1 = _huePointerY / (_svWidgetSize * sizeConfig.blockSmallest);
    h = 360.0 - (h_1 * 360.0);
    s = (_svPointer.x / (_svWidgetSize * sizeConfig.blockSmallest));
    v = 1.0 - (_svPointer.y / (_svWidgetSize * sizeConfig.blockSmallest));
    // get
    var hsvColor = HSVColor.fromAHSV(_colorOpacity, h, s, v);

    _selectedSpectrumColor = hsvColor.withSaturation(1).withValue(1).toColor();
    _selectedColor =  hsvColor.toColor();

    _updateEntryWidget();
  }

  void _updateEntryWidget(){
    widget.onSelectFunction?.call(_selectedColor);
    entry?.markNeedsBuild();
  }
}
