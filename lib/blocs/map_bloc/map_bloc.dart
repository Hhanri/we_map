import 'dart:async';

import 'package:we_map/models/log_model.dart';
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
  Completer<GoogleMapController> mapController = Completer();
  final StreamController<LogModel?> tempLogStream = StreamController<LogModel?>.broadcast();
  final StreamController<List<LogModel>> logsController = StreamController<List<LogModel>>();
  MapBloc({required this.firebaseService}) : super(MainInitial()) {

    void listenToLogs() {
      logsController.addStream(firebaseService.getLogsStream());
    }

    on<MainInitializeEvent>((event, emit) async {
      emit(MainInitializedState());
      listenToLogs();
    });

    on<LoadMapControllerEvent>((event, emit) {
      mapController.complete(event.controller);
    });

    on<AddLogEvent>((event, emit) async {
      await firebaseService.setLog(logModel: event.log);
      tempLogStream.sink.add(null);
    });

    on<AddTemporaryMarker>((event, emit) async {
      tempLogStream.add(LogModel.emptyLog(geoFirePoint: event.point.geoFireFromLatLng()));
    });

    on<CenterCameraEvent>((event, emit) async {
      if (await LocationService.getLocationPermission()) {
        final GoogleMapController googleMapController = await mapController.future;
        final Position position = await LocationService.getLocation();
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: position.latLngFromPosition(), zoom: 18 )
          )
        );
      } else {
        print("NO LOCATION PERMISSION");
      }
    });
  }
  @override
  Future<void> close() {
    print("DISPOSING MAP BLOC");
    logsController.close();
    tempLogStream.close();
    mapController.future.then((controller) async => controller.dispose());
    return super.close();
  }
}
