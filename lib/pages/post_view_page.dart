import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/network_images_list_view_widget.dart';

class PostViewPage extends StatelessWidget {
  final PostModel post;
  const PostViewPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBarWidget(),
      body: Padding(
        padding: DisplayConstants.scaffoldPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: const Text('Date'),
                trailing: Text(post.date.formatDate()),
              ),
              ListTile(
                title: const Text('Title'),
                trailing: Text(post.postTitle),
              ),
              ListTile(
                title: const Text('Description'),
                subtitle: Text(post.postDescription,),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width*0.5,
                child: NetworkImagesListViewWidget(
                  stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getImagesStream(post: post),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
