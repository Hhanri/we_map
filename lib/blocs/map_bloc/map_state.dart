part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class MainInitial extends MapState {}

class MainInitializedState extends MapState {
  final CameraPosition camera;

  MainInitializedState({required this.camera});
}