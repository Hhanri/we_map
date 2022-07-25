import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/icon_button_widget.dart';
import 'package:we_map/widgets/like_dislike_widget.dart';
import 'package:we_map/widgets/network_images_list_view_widget.dart';

class PostViewPage extends StatelessWidget {
  final PostModel post;
  const PostViewPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PostModel>(
      stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getSinglePostStream(post: post),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: const DefaultAppBarWidget(),
          body: Padding(
            padding: DisplayConstants.scaffoldPadding,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height ,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(AppStringsConstants.date),
                      trailing: Text(post.date.formatDate()),
                    ),
                    ListTile(
                      title: const Text(AppStringsConstants.title),
                      trailing: Text(post.postTitle),
                    ),
                    ListTile(
                      title: const Text(AppStringsConstants.description),
                      subtitle: Text(post.postDescription,),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width*0.5,
                      child: NetworkImagesListViewWidget(
                        stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getImagesStream(post: post),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PostLikeDislikeWidget(post: snapshot.data ?? post),
                        GradientButtonWidget(
                          icon: Icons.mode_comment_outlined,
                          onPressed: () {
                            AppRouter.pushNamed(AppRouter.commentsRoute, arguments: post);
                          }
                        )
                      ]
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
