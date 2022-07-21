import 'package:we_map/models/post_model.dart';
import 'package:we_map/widgets/post_list_tile_widget.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class PostsListViewWidget extends StatelessWidget {
  final Stream<List<PostModel>> stream;
  final bool isOwner;
  const PostsListViewWidget({Key? key, required this.stream, required this.isOwner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final PostModel post = snapshot.data![index];
              return PostListTileWidget(post: post, isOwner: isOwner,);
            }
          );
        }
        return const LoadingWidget();
      },
    );
  }
}
