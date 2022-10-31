import 'package:flutter/material.dart';

import '../manager/application_manager.dart';

Widget loadingScreen() {
  return Center(child: CircularProgressIndicator(backgroundColor: ApplicationManager.instance.theme.primaryBackgroundColor, color: ApplicationManager.instance.theme.primaryColor));
}