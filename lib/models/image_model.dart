import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';

class ImageModel extends Equatable {
  final String parentArchiveId;
  final String path;
  const ImageModel({required this.parentArchiveId, required this.path});

  static Map<String, dynamic> toJson(ImageModel image) {
    return {
      FirebaseConstants.parentArchiveId: image.parentArchiveId,
      FirebaseConstants.path: image.path
    };
  }

  static ImageModel fromJson(Map<String, dynamic> json) {
    return ImageModel(
      parentArchiveId: json[FirebaseConstants.parentArchiveId],
      path: json[FirebaseConstants.path],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [parentArchiveId, path];
}