
import 'package:adhan/adhan.dart';

class PrayerTimesHelper {
  late Coordinates coordinates;
  late CalculationParameters calculationParameters;
  late DateTime initDate;
  List<PrayerData> prayerTimes = List.empty(growable: true);
  int currentPrayerIndex = -1;
  int nextPrayerIndex = -1;

  PrayerTimesHelper(this.coordinates,this.calculationParameters) {
    PrayerTimes prayers = PrayerTimes.today(
        coordinates,
        calculationParameters
    );
    initDate = DateTime.now();
    if(prayers.currentPrayer().index == Prayer.isha.index){
      prayers = PrayerTimes(coordinates, DateComponents.from(initDate.add(const Duration(days: 1))), calculationParameters);
      currentPrayerIndex = prayers.currentPrayer().index;
    }
    for(int i = 0; i < Prayer.values.length; i++){
      prayerTimes.add(initPrayerData(prayers, i));
    }
    //print(prayerTimes.toString());
    currentPrayerIndex = prayers.currentPrayer().index;
    nextPrayerIndex = currentPrayerIndex + 1;
    if(nextPrayerIndex >= Prayer.values.length)
    {
      nextPrayerIndex = Prayer.fajr.index;
    }
    //print("c.CP: $currentPrayerIndex c.NP: $nextPrayerIndex");
  }
  void updatePrayers(){
    final currentDate = DateTime.now();
    if(initDate.day != currentDate.day){
      initDate = DateTime.now();
      final prayers = PrayerTimes(coordinates, DateComponents.from(initDate.add(const Duration(days: 1))), calculationParameters);
      currentPrayerIndex = prayers.currentPrayer().index;
      prayerTimes.clear();
      for(int i = 0; i < Prayer.values.length; i++){
        prayerTimes.add(initPrayerData(prayers, i));
      }
    }
    final currentPrayerDate = prayerTimes[nextPrayerIndex].prayerDatTime;
    int ratio = currentPrayerDate.difference(currentDate).inSeconds;
    //print("Difference in seconds: $ratio | $currentPrayerDate - $currentDate");
    if(ratio <= 0){
      currentPrayerIndex++;
      nextPrayerIndex++;

      if(currentPrayerIndex >= Prayer.values.length)
      {
        currentPrayerIndex = Prayer.fajr.index;
      }
      if(nextPrayerIndex >= Prayer.values.length)
      {
        nextPrayerIndex = Prayer.fajr.index;
      }
    }
  }
  PrayerData getPrayer(int index){
    return prayerTimes[index];
  }
  PrayerData getNextPrayer(){
    //print("next prayer index: $nextPrayerIndex");
    return getPrayer(nextPrayerIndex);
  }
  PrayerData getCurrentPrayer(){
    //print("current prayer index: $currentPrayerIndex");
    return getPrayer(currentPrayerIndex);
  }
  PrayerData initPrayerData(PrayerTimes prayers, int index){
    final prayer = Prayer.values[index];
    switch(prayer){
      case Prayer.fajr:
        return PrayerData(prayers.currentPrayerByDateTime(prayers.fajr), prayers.fajr);
      case Prayer.sunrise:
        return PrayerData(prayers.currentPrayerByDateTime(prayers.sunrise), prayers.sunrise);
      case Prayer.dhuhr:
        return PrayerData(prayers.currentPrayerByDateTime(prayers.dhuhr), prayers.dhuhr);
      case Prayer.asr:
        return PrayerData(prayers.currentPrayerByDateTime(prayers.asr), prayers.asr);
      case Prayer.maghrib:
        return PrayerData(prayers.currentPrayerByDateTime(prayers.maghrib), prayers.maghrib);
      case Prayer.isha:
        return PrayerData(prayers.currentPrayerByDateTime(prayers.isha), prayers.isha);
      default:
        return PrayerData(Prayer.none, DateTime.now());
    }
  }
}
class PrayerData {
  Prayer prayer;
  DateTime prayerDatTime;
  PrayerData(this.prayer, this.prayerDatTime);
  @override
  String toString() {
    return "${prayer.index}-${prayer.name}: $prayerDatTime";
  }
}