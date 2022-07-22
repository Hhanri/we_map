import 'package:we_map/blocs/topic_form_bloc/topic_form_bloc.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListTileWidget extends StatelessWidget {
  final PostModel post;
  final bool isOwner;
  const PostListTileWidget({Key? key, required this.post, required this.isOwner}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(post.date.formatDate()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ViewPostButton(post: post,),
          if (isOwner) DeletePostButton(post: post)
        ],
      )
    );
  }
}

class ViewPostButton extends StatelessWidget {
  final PostModel post;
  const ViewPostButton({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        AppRouter.pushNamed(AppRouter.postViewRoute, arguments: post);
      },
      icon: const Icon(Icons.remove_red_eye),
    );
  }
}

class DeletePostButton extends StatelessWidget {
  final PostModel post;
  const DeletePostButton({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<TopicFormBloc>().add(DeletePostEvent(post: post));
      },
      icon: const Icon(Icons.delete),
    );
  }
}

