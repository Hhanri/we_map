import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/comment_reply_cubit/comment_reply_cubit.dart';
import 'package:we_map/models/coment_model.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class WriteCommentReplyPage extends StatelessWidget {
  final PostModel? post;
  final CommentModel? comment;
  const WriteCommentReplyPage({Key? key, this.post, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentReplyCubit>(
      create: (context) => CommentReplyCubit(
        context: context,
        firestoreService: RepositoryProvider.of<FirebaseFirestoreService>(context),
        post: post
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        resizeToAvoidBottomInset: true,
        body: InkWell(
          onTap: () => AppRouter.pop(),
          splashFactory: NoSplash.splashFactory,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<CommentReplyCubit, CommentReplyState>(
                builder: (context, state) {
                  return CommentTextFieldWidget(
                    node: context.read<CommentReplyCubit>().node,
                    controller: context.read<CommentReplyCubit>().textController,
                    onSend: () => context.read<CommentReplyCubit>().send()
                  );
                },
              )
            ],
          ),
        ),
      )
    );
  }
}
