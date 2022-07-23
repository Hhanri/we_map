import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:we_map/models/custom_camera_model.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/services/location_service.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final FirebaseFirestoreService firebaseService;
  final FirebaseAuthService authService;
  late GoogleMapController mapController;
  final StreamController<TopicModel?> tempTopicStream = StreamController<TopicModel?>.broadcast();
  final StreamController<List<TopicModel>> topicsController = StreamController<List<TopicModel>>();

  final BehaviorSubject<CustomCameraModel> cameraObs = BehaviorSubject<CustomCameraModel>();

  MapBloc({required this.firebaseService, required this.authService}) : super(const MainInitial(isLoading: false)) {

    CustomCameraModel tempCamera = const CustomCameraModel(center: LatLng(0,0), radius: 0);

    void listenToTopics() async {
      if (!isClosed) {
        cameraObs.switchMap((camera) {
          return firebaseService.getTopicsStreamRadius(center: camera.center.geoFireFromLatLng(), radius: camera.radius);
        }).listen((event) {topicsController.add(event);});
      }
    }

    on<LoadMapControllerEvent>((event, emit) {
      mapController = event.controller;
      listenToTopics();
    });

    on<AddTopicEvent>((event, emit) async {
      await firebaseService.setTopic(topicModel: event.topic);
      tempTopicStream.sink.add(null);
    });

    on<AddTemporaryMarker>((event, emit) async {
      tempTopicStream.add(
        TopicModel.emptyTopic(
          geoFirePoint: event.point.geoFireFromLatLng(),
          uid: authService.getUserId
        )
      );
    });

    on<MainInitializeEvent>((event, emit) async {
      final target = await LocationService.getLocation();
      final camera = CameraPosition(target: target.latLngFromPosition(), zoom: 12);
      tempCamera = CustomCameraModel(center: camera.target, radius: 9185.5);
      add(CameraStopEvent());
      emit(MainInitializedState(camera: camera, isLoading: false));
    });

    on<RequestPermissionEvent>((event, emit) async {
      emit(const NoLocationPermissionState(isLoading: true));
        final bool value = await LocationService.getLocationPermission();
        if (value) {
          add(MainInitializeEvent());
        } else {
          emit(const NoLocationPermissionState(isLoading: false, errorMessage: "PERMISSION DENIED"));
        }
    });

    on<CameraMoveEvent>((event, emit) async {
      final LatLngBounds region = await mapController.getVisibleRegion();
      final double radius = firebaseService.getDistance(northeast: region.northeast, southwest: region.southwest) / 2;
      tempCamera = CustomCameraModel(center: event.center, radius: radius);
    });

    on<CameraStopEvent>((event, emit) {
      cameraObs.add(tempCamera);
    });

  }
  @override
  Future<void> close() {
    cameraObs.close();
    topicsController.close();
    tempTopicStream.close();
    mapController.dispose();
    return super.close();
  }
}
