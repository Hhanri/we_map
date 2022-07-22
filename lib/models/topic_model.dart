import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TopicModel extends Equatable {
  final String uid;
  final String topicId;
  final GeoFirePoint geoPoint;
  final String topicTitle;
  final String topicDescription;

  const TopicModel({
    required this.uid,
    required this.topicId,
    required this.geoPoint,
    required this.topicTitle,
    required this.topicDescription
  });
  
  factory TopicModel.editedTopic({required TopicModel oldTopic, required String newTitle, required String newDescription}) {
    return TopicModel(uid: oldTopic.uid, topicId: oldTopic.topicId, geoPoint: oldTopic.geoPoint, topicTitle: newTitle, topicDescription: newDescription);
  }
  
  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      uid: json[FirebaseConstants.uid],
      topicId: json[FirebaseConstants.topicId],
      geoPoint: (json[FirebaseConstants.position][FirebaseConstants.geopoint] as GeoPoint).geoFireFromGeoPoint(),
      topicTitle: json[FirebaseConstants.topicTitle],
      topicDescription: json[FirebaseConstants.topicDescription]
    );
  }

  static Map<String, dynamic> toJson({required TopicModel model}) {
    return {
      FirebaseConstants.uid: model.uid,
      FirebaseConstants.topicId: model.geoPoint.hash,
      FirebaseConstants.position: model.geoPoint.data,
      FirebaseConstants.topicTitle: model.topicTitle,
      FirebaseConstants.topicDescription: model.topicDescription
    };
  }

  static TopicModel emptyTopic({required GeoFirePoint geoFirePoint, required String uid}) {
    return TopicModel(
      uid: uid,
      topicId: geoFirePoint.hash,
      geoPoint: geoFirePoint,
      topicTitle: "",
      topicDescription: ""
    );
  }

  static Marker getMarker({required BuildContext context, required TopicModel topic, required String uid}) {
    return Marker(
      icon: topic.uid == uid ? BitmapDescriptor.defaultMarker : BitmapDescriptor.defaultMarkerWithHue(200),
      markerId: MarkerId(topic.geoPoint.hash),
      position: topic.geoPoint.latLngFromGeoFire(),
      infoWindow: InfoWindow(title: topic.topicTitle),
      onTap: () {
        //AppRouter.pushNamed(AppRouter.topicFormRoute, arguments: topic);
        if (uid !=  topic.uid) {
          AppRouter.pushNamed(AppRouter.topicViewRoute, arguments: topic);
        } else {
          AppRouter.pushNamed(AppRouter.topicFormRoute, arguments: topic);
        }
      }
    );
  }
  
  static Marker getTempMarker({required BuildContext context, required TopicModel topic}) {
    return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(90),
      markerId: MarkerId(topic.geoPoint.hash),
      position: topic.geoPoint.latLngFromGeoFire(),
      infoWindow: InfoWindow(title: topic.topicTitle),
      onTap: () {}
    );
  }

  static Set<Marker> getMarkers({required BuildContext context, required List<TopicModel> topics, required String uid}) {
    final Set<Marker> markers = topics.map((topic) {
      return getMarker(context: context, topic: topic, uid: uid);
    }).toSet();
    return markers;
  }

  @override
  List<Object?> get props => [topicId, geoPoint, topicTitle, uid];
}
