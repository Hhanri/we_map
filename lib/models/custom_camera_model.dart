import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomCameraModel extends Equatable {
  final LatLng center;
  final double radius;

  const CustomCameraModel({required this.center, required this.radius});

  @override
  // TODO: implement props
  List<Object?> get props => [center, radius];
}