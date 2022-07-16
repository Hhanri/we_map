import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';

class ImageModel extends Equatable {
  final String uid;
  final String parentLogId;
  final String parentArchiveId;
  final String path;
  const ImageModel({
    required this.uid,
    required this.parentLogId,
    required this.parentArchiveId,
    required this.path
  });

  static Map<String, dynamic> toJson(ImageModel image) {
    return {
      FirebaseConstants.uid: image.uid,
      FirebaseConstants.parentLogId: image.parentLogId,
      FirebaseConstants.parentArchiveId: image.parentArchiveId,
      FirebaseConstants.path: image.path
    };
  }

  static ImageModel fromJson(Map<String, dynamic> json) {
    return ImageModel(
      uid: FirebaseConstants.uid,
      parentLogId: json[FirebaseConstants.parentLogId],
      parentArchiveId: json[FirebaseConstants.parentArchiveId],
      path: json[FirebaseConstants.path],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [parentArchiveId, path];
}