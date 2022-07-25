import 'package:flutter/material.dart';
import 'package:we_map/models/coment_model.dart';
import 'package:we_map/widgets/comment_widget.dart';

class CommentsListViewWidget extends StatelessWidget {
  final List<CommentModel> comments;
  const CommentsListViewWidget({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) {
        return CommentWidget(comment: comments[index]);
      },
    );
  }
}
