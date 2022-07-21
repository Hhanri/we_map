import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';

class ImageModel extends Equatable {
  final String uid;
  final String parentTopicId;
  final String parentPostId;
  final String path;
  const ImageModel({
    required this.uid,
    required this.parentTopicId,
    required this.parentPostId,
    required this.path
  });

  static Map<String, dynamic> toJson(ImageModel image) {
    return {
      FirebaseConstants.uid: image.uid,
      FirebaseConstants.parentTopicId: image.parentTopicId,
      FirebaseConstants.parentPostId: image.parentPostId,
      FirebaseConstants.path: image.path
    };
  }

  static ImageModel fromJson(Map<String, dynamic> json) {
    return ImageModel(
      uid: FirebaseConstants.uid,
      parentTopicId: json[FirebaseConstants.parentTopicId],
      parentPostId: json[FirebaseConstants.parentPostId],
      path: json[FirebaseConstants.path],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [parentPostId, path];
}