import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/coment_model.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_firestore_service.dart';

part 'comment_reply_state.dart';

class CommentReplyCubit extends Cubit<CommentReplyState> {
  final CommentModel? comment;
  final PostModel? post;
  final FirebaseFirestoreService firestoreService;
  final BuildContext context;
  final FocusNode node = FocusNode()..requestFocus();
  CommentReplyCubit({required this.context, required this.firestoreService, this.comment,  this.post}) : super(CommentReplyInitial());

  final TextEditingController textController = TextEditingController();

  void send() async {
    if (textController.text.isEmpty) return;
    if (post != null) {
      try {
        AppRouter.pop();
        await firestoreService.setComment(parentTopicId: post!.parentTopicId, parentPostId: post!.postId, commentContent: textController.text);
      } on FirebaseException catch(error) {
        showErrorMessage(errorMessage: error.message!, context: context);
      }
    }
    if (comment != null) {

    }
  }

  @override
  Future<void> close() {
    textController.dispose();
    return super.close();
  }
}
