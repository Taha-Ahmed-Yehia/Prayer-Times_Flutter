
import 'package:geolocator/geolocator.dart';
import 'package:prayer_times/Screens/show_dialog_window.dart';

Future<Position> determinePosition({bool showServiceUnenabledMessage = true}) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if(showServiceUnenabledMessage) {
      showCustomDialog("Note", "Location services are disabled.\nplease make sure to active Location service in your device.");
    }
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      showCustomDialog("Warning!", "Location permissions are permanently denied, we cannot request permission to location services.");
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      showCustomDialog("Warning!", "Location permissions are denied, we cannot request permission to location services.");
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}