import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

extension GeoFireFromLatLng on LatLng {
  GeoFirePoint geoFireFromLatLng() {
    return GeoFirePoint(latitude, longitude);
  }
}

extension GeoFireFromGeoPoint on GeoPoint {
  GeoFirePoint geoFireFromGeoPoint() {
    return GeoFirePoint(latitude, longitude);
  }
}

extension GeoFireFromPosition on Position{
  GeoFirePoint geoFireFromPosition() {
    return GeoFirePoint(latitude, longitude);
  }
}

extension LatLngFromGeoFire on GeoFirePoint {
  LatLng latLngFromGeoFire() {
    return LatLng(latitude, longitude);
  }
}

extension LatlngFromPosition on Position {
  LatLng latLngFromPosition() {
    return LatLng(latitude, longitude);
  }
}

extension FormatDate on DateTime {
  String formatDate() {
    return DateFormat('dd-MM-yyyy').add_Hm().format(this);
  }
}

extension ParseStringToDate on String? {
  DateTime parseStringToDate() {
    return DateFormat('dd-MM-yyyy').add_Hm().parseStrict(this!);
  }
}