import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/models/coment_model.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/like_dislike_widget.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<String>(
            future: RepositoryProvider.of<FirebaseFirestoreService>(context).getUsername(uid: comment.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!, style: Theme.of(context).textTheme.bodyText1,);
              }
              return Container();
            }
          ),
          Text(comment.comment, style: Theme.of(context).textTheme.bodyText2,),
          CommentLikeDislikeWidget(comment: comment)
        ],
      ),
    );
  }
}
