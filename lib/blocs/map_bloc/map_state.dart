part of 'map_bloc.dart';

@immutable
abstract class MapState {
  final bool isLoading;
  final String? errorMessage;

  const MapState({required this.isLoading, this.errorMessage});
}

class MainInitial extends MapState {
  const MainInitial({required super.isLoading, super.errorMessage});
}

class MainInitializedState extends MapState {
  final CameraPosition camera;

  const MainInitializedState({required this.camera, required super.isLoading, super.errorMessage});
}

class NoLocationPermissionState extends MapState {
  const NoLocationPermissionState({required super.isLoading, super.errorMessage});
}