import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/constants/firebase_constants.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/icon_button_widget.dart';

class IconValueButtonWidget extends StatelessWidget {
  final int value;
  final IconData icon;
  final VoidCallback onPressed;
  final Future<bool> future;
  const IconValueButtonWidget({Key? key, required this.value, required this.icon, required this.onPressed, required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: future,
      builder: (context, isSelected) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isSelected.data ?? false
              ? GradientButtonWidget(
                  icon: icon,
                  onPressed: onPressed
                )
              : WhiteIconButtonWidget(
                  icon: icon,
                  onPressed: onPressed
                ),
            Text(value != 0 ? value.toString() : '')
          ],
        );
      }
    );
  }
}

class PostLikeDislikeWidget extends StatelessWidget {
  final PostModel post;
  const PostLikeDislikeWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconValueButtonWidget(
          value: post.likes,
          icon: Icons.keyboard_arrow_up_outlined,
          onPressed: () {
            RepositoryProvider.of<FirebaseFirestoreService>(context).likeDislikePost(post: post, optedInField: FirebaseConstants.likedPosts, optedOutField: FirebaseConstants.dislikedPosts);
          },
          future: RepositoryProvider.of<FirebaseFirestoreService>(context).getPostLikesDislikesFuture(postId: post.postId, field: FirebaseConstants.likedPosts),
        ),
        IconValueButtonWidget(
          value: post.dislikes,
          icon: Icons.keyboard_arrow_down_outlined,
          onPressed: () {
            RepositoryProvider.of<FirebaseFirestoreService>(context).likeDislikePost(post: post, optedInField: FirebaseConstants.dislikedPosts, optedOutField: FirebaseConstants.likedPosts);
          },
          future: RepositoryProvider.of<FirebaseFirestoreService>(context).getPostLikesDislikesFuture(postId: post.postId, field: FirebaseConstants.dislikedPosts),
        )
      ],
    );
  }
}
