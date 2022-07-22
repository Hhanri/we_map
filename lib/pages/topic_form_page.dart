import 'package:we_map/blocs/topic_form_bloc/topic_form_bloc.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/pages/topic_view_page.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:we_map/widgets/posts_list_view_widget.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/text_button_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicFormPage extends StatelessWidget {
  final TopicModel initialTopic;
  const TopicFormPage({Key? key, required this.initialTopic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TopicFormBloc>(
      create: (context) => TopicFormBloc(
        context: context,
        initialTopic: initialTopic,
        firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context),
        authService: RepositoryProvider.of<FirebaseAuthService>(context)
      ),
      child: BlocConsumer<TopicFormBloc, TopicFormState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen.instance().show(context: context, text: AppStringsConstants.loading);
          } else {
            LoadingScreen.instance().hide();
          }
          if (state.errorMessage != null) {
            showErrorMessage(errorMessage: state.errorMessage!, context: context);
          }
        },
        builder: (context, state) {
          final TopicModel topic = context.watch<TopicFormBloc>().initialTopic;
          if (state is TopicFormViewState) {
            return TopicViewPage(topic: topic, isOwner: true);
          }
          if (state is TopicFormEditState) {
            return TopicFormEditingView(currentState: state);
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}

class TopicFormEditingView extends StatelessWidget {
  final TopicFormState currentState;
  const TopicFormEditingView({Key? key, required this.currentState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopicFormEditingAppBarWidget(
        onCancel: () {
          context.read<TopicFormBloc>().add(EmitViewingState(isLoading: false));
        },
        onValidate: () {
          context.read<TopicFormBloc>().add(EditTopicEvent(currentState: currentState));
        },
      ),
      body: Padding(
        padding: DisplayConstants.scaffoldPadding,
        child: Form(
          key: context.read<TopicFormBloc>().formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormFieldWidget(
                  parameters: TitleParameters(controller: context.read<TopicFormBloc>().topicTitleController),
                ),
                TextFormFieldWidget(
                  parameters: DescriptionParameters(controller: context.read<TopicFormBloc>().topicDescriptionController),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

