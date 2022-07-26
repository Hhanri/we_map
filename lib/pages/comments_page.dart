import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/models/coment_model.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/comments_list_view_widget.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class CommentPage extends StatelessWidget {
  final PostModel post;
  const CommentPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentModel>>(
      stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getCommentsStream(post: post),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<CommentModel> comments = snapshot.data!;
          return Scaffold(
            appBar: CommentAppBarWidget(number: comments.length),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FakeCommentTextFieldWidget(onTap: () => AppRouter.pushNamed(AppRouter.writeCommentRoute, arguments: post)),
                  CommentsListViewWidget(comments: comments)
                ],
              ),
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
