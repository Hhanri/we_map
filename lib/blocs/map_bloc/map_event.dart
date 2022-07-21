part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class MainInitializeEvent extends MapEvent {}

class RequestPermissionEvent extends MapEvent {}

class LoadMapControllerEvent extends MapEvent{
  final GoogleMapController controller;

  LoadMapControllerEvent({required this.controller});
}

class AddTopicEvent extends MapEvent {
  final BuildContext context;
  final TopicModel topic;
  AddTopicEvent({required this.context, required this.topic});
}

class AddTemporaryMarker extends MapEvent {
  final LatLng point;

  AddTemporaryMarker({required this.point});
}

class CenterCameraEvent extends MapEvent {}

class CameraMoveEvent extends MapEvent {
  final LatLng center;

  CameraMoveEvent({required this.center});
}

class CameraStopEvent extends MapEvent {}