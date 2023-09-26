import 'dart:async';

import 'package:flutter/foundation.dart';

class CurrentTime extends ChangeNotifier{
  DateTime date = DateTime.now();
  //late Timer _timer;
  
  CurrentTime(){
    /*_timer =*/ Timer.periodic(const Duration(seconds: 1), (timer) { 
      date = DateTime.now();
      notifyListeners();
    });
  }
}