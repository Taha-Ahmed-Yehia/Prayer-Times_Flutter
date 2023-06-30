
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Data/app_theme_data.dart';
import '../Data/size_config.dart';
import '../Models/AppTheme.dart';

class MenuButton extends StatefulWidget {
  final Function? onSelect;
  final int selectedItemID;
  final List<MenuItem> menuItems;
  final double iconSize;
  final IconData icon;

  final double menuWidth;
  const MenuButton(this.menuItems, {this.menuWidth = 100, this.icon = FontAwesomeIcons.gear,this.iconSize = 20, this.onSelect, this.selectedItemID = 0,Key? key}) : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _isDropDown = false;
  OverlayEntry? entry;
  int selectedItemID = 0;

  @override
  void initState() {
    super.initState();
    selectedItemID = widget.selectedItemID;
  }
  @override
  void dispose() {
    super.dispose();
    if(_isDropDown) {
      entry?.remove();
    }
  }

  void showOverlay(BuildContext context, SizeConfig sizeConfig){
    var overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
        builder: (context) => Consumer<AppThemeData>(
          builder: (context, appThemeData, child) => Stack(
            children: [
              GestureDetector(
                onTap: (){
                  setState((){
                    _isDropDown = !_isDropDown;
                  });
                  entry?.remove();
                },
              ),
              Positioned(
                  left: offset.dx - (size.width + widget.iconSize * .5) - widget.menuWidth * .5 ,
                  top: offset.dy + size.height,
                  width: widget.menuWidth,
                  child: buildOverly(sizeConfig, appThemeData)
              ),
            ],
          ),
        )
    );
    overlay!.insert(entry!);
  }

  Widget buildOverly(SizeConfig sizeConfig, AppThemeData appThemeData) {
    return Material(
        borderRadius: BorderRadius.circular(10 * sizeConfig.blockSmallest),
        color: appThemeData.selectedTheme.primaryColor,
        elevation: 8,
        child:  Padding(
          padding: EdgeInsets.all(5 * sizeConfig.blockSmallest),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.menuItems.map((e) => dropDownItemTile(e, appThemeData.selectedTheme, sizeRatio: sizeConfig.blockSmallest)).toList(),
          ),
        )
    );
  }

  Widget dropDownItemTile(MenuItem item, AppTheme theme, {double sizeRatio = 1}){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryLightColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((widget.menuWidth * .05) * sizeRatio)
        ),
      ),
      onPressed: (){
        widget.onSelect?.call();
        item.onSelect?.call();

        entry?.remove();
        setState(() {
          selectedItemID = widget.menuItems.indexOf(item);
          _isDropDown = !_isDropDown;
        });
      },
      child: FittedBox(child: Text(item.title, textAlign: TextAlign.center, style: TextStyle(color: theme.textColor, ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);
    return Consumer<AppThemeData>(
        builder: (context, appThemeData, child) => GestureDetector(
          onTap: (){
            setState(() {
              _isDropDown = !_isDropDown;
              if(_isDropDown){
                WidgetsBinding.instance!.addPostFrameCallback((_)=> showOverlay(context, sizeConfig));
              }else{
                entry?.remove();
              }
            });
          },
          child: Icon(
            widget.icon,
            color: appThemeData.selectedTheme.textColor,
            size: widget.iconSize,
          ),
        )
    );
  }
}

class MenuItem {
  String title;
  Function onSelect;
  MenuItem(this.title, this.onSelect);
}
