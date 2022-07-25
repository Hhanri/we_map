import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/models/coment_model.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/loading_widget.dart';

class CommentPage extends StatelessWidget {
  final PostModel post;
  const CommentPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentModel>>(
      stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getCommentsStream(post: post),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: CommentAppBarWidget(number: snapshot.data!.length),
            body: TextButton(
              onPressed: () {
                RepositoryProvider.of<FirebaseFirestoreService>(context).setComment(
                  parentTopicId: post.parentTopicId,
                  parentPostId: post.postId,
                  commentContent: "this is a test"
                );
              },
              child: const Text("test send comment"),
            ),
          );
        }
        return const Scaffold(
          appBar: DefaultAppBarWidget(),
          body: LoadingWidget(),
        );
      }
    );
  }
}
