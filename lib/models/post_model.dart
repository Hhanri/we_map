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
  final int likes;
  final int dislikes;

  const PostModel({
    required this.uid,
    required this.postId,
    required this.parentTopicId,
    required this.date,
    required this.postTitle,
    required this.postDescription,
    required this.likes,
    required this.dislikes
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      uid: json[FirebaseConstants.uid],
      postId: json[FirebaseConstants.postId],
      parentTopicId: json[FirebaseConstants.parentTopicId],
      date: (json[FirebaseConstants.date] as Timestamp).toDate(),
      postTitle: json[FirebaseConstants.postTitle],
      postDescription: json[FirebaseConstants.postDescription],
      likes: json[FirebaseConstants.likes],
      dislikes: json[FirebaseConstants.dislikes]
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
      FirebaseConstants.likes: FieldValue.increment(0),
      FirebaseConstants.dislikes: FieldValue.increment(0)
    };
  }

  @override
  List<Object?> get props => [date, postTitle, postDescription];
}