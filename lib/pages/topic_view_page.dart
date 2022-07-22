import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/topic_form_bloc/topic_form_bloc.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/posts_list_view_widget.dart';
import 'package:we_map/widgets/text_button_widget.dart';

class TopicViewPage extends StatelessWidget {
  final TopicModel topic;
  final bool isOwner;
  const TopicViewPage({Key? key, required this.topic, required this.isOwner}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    late PreferredSizeWidget appBar;
    if (isOwner) {
      appBar = TopicFormOwnerAppBarWidget(
        onEdit: () => context.read<TopicFormBloc>().add(EmitEditingState(isLoading: false)),
        onDelete: () => context.read<TopicFormBloc>().add(DeleteTopicEvent()),
      );
    } else {
      appBar = const DefaultAppBarWidget();
    }
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: DisplayConstants.scaffoldPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: const Text(AppStringsConstants.title),
                trailing: Text(topic.topicTitle),
              ),
              ListTile(
                title: const Text(AppStringsConstants.description),
                trailing: FittedBox(child: Text(topic.topicDescription)),
              ),
              if (isOwner) TextButtonWidget(
                onPressed: () {
                  context.read<TopicFormBloc>().add(AddPostEvent());
                },
                text: AppStringsConstants.add
              ),
              PostsListViewWidget(
                isOwner: isOwner,
                stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getPostsStream(topic: topic)
              )
            ],
          ),
        ),
      ),
    );
  }
}
