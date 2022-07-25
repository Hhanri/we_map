import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_map/constants/firebase_constants.dart';

class CommentModel {
  final String commentId;
  final String parentPostId;
  final String parentTopicId;
  final String uid;
  final String comment;
  final int likes;
  final int dislikes;
  final int replies;

  CommentModel({
    required this.commentId,
    required this.parentPostId,
    required this.parentTopicId,
    required this.uid,
    required this.comment,
    required this.likes,
    required this.dislikes,
    required this.replies
  });

  static Map<String, dynamic> toJson(CommentModel model) {
    return {
      FirebaseConstants.commentId: model.commentId,
      FirebaseConstants.uid: model.uid,
      FirebaseConstants.parentPostId: model.parentPostId,
      FirebaseConstants.parentTopicId: model.parentTopicId,
      FirebaseConstants.comment: model.comment,
      FirebaseConstants.replies: model.replies,
      FirebaseConstants.likes: FieldValue.increment(0),
      FirebaseConstants.dislikes: FieldValue.increment(0)
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json[FirebaseConstants.commentId],
      parentPostId: json[FirebaseConstants.parentPostId],
      parentTopicId: json[FirebaseConstants.parentTopicId],
      uid: json[FirebaseConstants.uid],
      comment: json[FirebaseConstants.comment],
      likes: json[FirebaseConstants.likes],
      dislikes: json[FirebaseConstants.dislikes],
      replies: json[FirebaseConstants.replies]
    );
  }
}