import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/services/location_service.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final FirebaseFirestoreService firebaseService;
  final FirebaseAuthService authService;
  late GoogleMapController mapController;
  final StreamController<LogModel?> tempLogStream = StreamController<LogModel?>.broadcast();
  final StreamController<List<LogModel>> logsController = StreamController<List<LogModel>>();
  final BehaviorSubject<double> radiusObs = BehaviorSubject<double>.seeded(0);
  final BehaviorSubject<LatLng> centerObs = BehaviorSubject<LatLng>();
  MapBloc({required this.firebaseService, required this.authService}) : super(MainInitial()) {

    void listenToLogs() async {
      if (!isClosed) {
        radiusObs.switchMap((radius) {
          return centerObs.switchMap((center) {
            return firebaseService.getLogsStreamRadius(center: center.geoFireFromLatLng(), radius: radius);
          });
        }).listen((event) {logsController.add(event);});
      }
    }

    on<MainInitializeEvent>((event, emit) async {
      if (await LocationService.getLocationPermission()) {
        final target = await LocationService.getLocation();
        final camera = CameraPosition(target: target.latLngFromPosition(), zoom: 12);
        centerObs.add(camera.target);
        emit(MainInitializedState(camera: camera));
      }
    });

    on<LoadMapControllerEvent>((event, emit) {
      mapController = event.controller;
      listenToLogs();
    });

    on<AddLogEvent>((event, emit) async {
      await firebaseService.setLog(logModel: event.log);
      tempLogStream.sink.add(null);
    });

    on<AddTemporaryMarker>((event, emit) async {
      tempLogStream.add(
        LogModel.emptyLog(
          geoFirePoint: event.point.geoFireFromLatLng(),
          uid: authService.getUserId
        )
      );
    });

    on<CenterCameraEvent>((event, emit) async {
      if (await LocationService.getLocationPermission()) {
        final Position position = await LocationService.getLocation();
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: position.latLngFromPosition(), zoom: 18 )
          )
        );
      } else {
        print("NO LOCATION PERMISSION");
      }
    });

    double tempRadius = 0;
    LatLng tempCenter = const LatLng(0, 0);

    on<CameraMoveEvent>((event, emit) async {
      final LatLngBounds region = await mapController.getVisibleRegion();
      final double radius = firebaseService.getDistance(northeast: region.northeast, southwest: region.southwest) / 2;
      tempRadius = radius;
      tempCenter = event.center;
    });

    on<CameraStopEvent>((event, emit) {
      radiusObs.add(tempRadius);
      centerObs.add(tempCenter);
    });
  }
  @override
  Future<void> close() {
    radiusObs.close();
    centerObs.close();
    logsController.close();
    tempLogStream.close();
    mapController.dispose();
    return super.close();
  }
}
