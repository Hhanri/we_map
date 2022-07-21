import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LogModel extends Equatable {
  final String uid;
  final String logId;
  final GeoFirePoint geoPoint;
  final String streetName;

  const LogModel({
    required this.uid,
    required this.logId,
    required this.geoPoint,
    required this.streetName,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      uid: json[FirebaseConstants.uid],
      logId: json[FirebaseConstants.logId],
      geoPoint: (json[FirebaseConstants.position][FirebaseConstants.geopoint] as GeoPoint).geoFireFromGeoPoint(),
      streetName: json[FirebaseConstants.streetName],
    );
  }

  static Map<String, dynamic> toJson({required LogModel model}) {
    return {
      FirebaseConstants.uid: model.uid,
      FirebaseConstants.logId: model.geoPoint.hash,
      FirebaseConstants.position: model.geoPoint.data,
      FirebaseConstants.streetName: model.streetName,
    };
  }

  static LogModel emptyLog({required GeoFirePoint geoFirePoint, required String uid}) {
    return LogModel(
      uid: uid,
      logId: geoFirePoint.hash,
      geoPoint: geoFirePoint,
      streetName: "",
    );
  }

  static Marker getMarker({required BuildContext context, required LogModel log, required String uid}) {
    return Marker(
      icon: log.uid == uid ? BitmapDescriptor.defaultMarker : BitmapDescriptor.defaultMarkerWithHue(200),
      markerId: MarkerId(log.geoPoint.hash),
      position: log.geoPoint.latLngFromGeoFire(),
      infoWindow: InfoWindow(title: log.streetName),
      onTap: () {
        AppRouter.pushNamed(AppRouter.logFormRoute, arguments: log);
        /*if (uid !=  log.logUid) {
          AppRouter.pushNamed(AppRouter.logViewRoute, arguments: log);
        } else {
          AppRouter.pushNamed(AppRouter.logFormRoute, arguments: log);
        }*/
      }
    );
  }
  
  static Marker getTempMarker({required BuildContext context, required LogModel log}) {
    return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(90),
      markerId: MarkerId(log.geoPoint.hash),
      position: log.geoPoint.latLngFromGeoFire(),
      infoWindow: InfoWindow(title: log.streetName),
      onTap: () {
        //navigate to logs page
      }
    );
  }

  static Set<Marker> getMarkers({required BuildContext context, required List<LogModel> logs, required String uid}) {
    final Set<Marker> markers = logs.map((log) {
      return getMarker(context: context, log: log, uid: uid);
    }).toSet();
    return markers;
  }

  @override
  List<Object?> get props => [logId, geoPoint, streetName, uid];
}
