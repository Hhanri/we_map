import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';

class PostModel extends Equatable {
  final String uid;
  final String postId;
  final String parentTopicId;
  final DateTime date;
  final String postTitle;
  final String postDescription;

  const PostModel({
    required this.uid,
    required this.postId,
    required this.parentTopicId,
    required this.date,
    required this.postTitle,
    required this.postDescription
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      uid: json[FirebaseConstants.uid],
      postId: json[FirebaseConstants.postId],
      parentTopicId: json[FirebaseConstants.parentTopicId],
      date: (json[FirebaseConstants.date] as Timestamp).toDate(),
      postTitle: json[FirebaseConstants.postTitle],
      postDescription: json[FirebaseConstants.postDescription]
    );
  }

  static Map<String, dynamic> toJson(PostModel model) {
    return {
      FirebaseConstants.uid: model.uid,
      FirebaseConstants.postId: model.postId,
      FirebaseConstants.parentTopicId: model.parentTopicId,
      FirebaseConstants.date: model.date,
      FirebaseConstants.postTitle: model.postTitle,
      FirebaseConstants.postDescription: model.postDescription,
    };
  }

  @override
  List<Object?> get props => [date, postTitle, postDescription];
}