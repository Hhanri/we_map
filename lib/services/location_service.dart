import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getLocation() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  static Future<bool> getLocationPermission() async {
    final LocationPermission value = await Geolocator.requestPermission();
    return value == LocationPermission.whileInUse || value == LocationPermission.always;
  }
}