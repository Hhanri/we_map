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

  static Map<String, dynamic> toJson(CommentModel comment) {
    return {
      FirebaseConstants.commentId: comment.commentId,
      FirebaseConstants.uid: comment.uid,
      FirebaseConstants.parentPostId: comment.parentPostId,
      FirebaseConstants.parentTopicId: comment.parentTopicId,
      FirebaseConstants.comment: comment.comment,
      FirebaseConstants.replies: comment.replies,
      FirebaseConstants.likes: comment.likes,
      FirebaseConstants.dislikes: comment.dislikes
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json[FirebaseConstants.commentId],
      parentPostId: json[FirebaseConstants.parentPostId],
      parentTopicId: json[FirebaseConstants.parentTopicId],
      uid: json[FirebaseConstants.uid],
      comment: json[FirebaseConstants.comment],
      likes: int.tryParse(json[FirebaseConstants.likes]) ?? 0,
      dislikes: int.tryParse(json[FirebaseConstants.dislikes]) ?? 0,
      replies: int.tryParse(json[FirebaseConstants.replies]) ?? 0
    );
  }
}