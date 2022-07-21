import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/posts_list_view_widget.dart';

class TopicViewPage extends StatelessWidget {
  final TopicModel topic;
  const TopicViewPage({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBarWidget(),
      body: Padding(
        padding: DisplayConstants.scaffoldPadding,
        child: Column(
          children: [
            ListTile(
              title: const Text('Street Name'),
              trailing: Text(topic.topicTitle),
            ),
            ListTile(
              title: const Text('Geopoint'),
              trailing: FittedBox(child: Text("[${topic.geoPoint.latitude.toStringAsFixed(5)}, ${topic.geoPoint.longitude.toStringAsFixed(5)}]")),
            ),
            Expanded(
              child: PostsListViewWidget(
                isOwner: false,
                stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getPostsStream(topic: topic)
              ),
            )
          ],
        ),
      ),
    );
  }
}
