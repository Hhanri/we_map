import 'package:we_map/blocs/topic_form_cubit/topic_form_cubit.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
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
    return BlocProvider<TopicFormCubit>(
      create: (context) => TopicFormCubit(
        context: context,
        initialTopic: initialTopic,
        firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context),
        authService: RepositoryProvider.of<FirebaseAuthService>(context)
      )..init(),
      child: BlocConsumer<TopicFormCubit, TopicFormState>(
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
          return Scaffold(
            appBar: FormAppBarWidget(
              text: AppStringsConstants.topicTitle,
              onDelete: () {
                context.read<TopicFormCubit>().deleteTopic();
              },
              onValidate: () {
                context.read<TopicFormCubit>().editTopic();
              },
            ),
            body: Padding(
              padding: DisplayConstants.scaffoldPadding,
              child: Form(
                key: context.read<TopicFormCubit>().formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormFieldWidget(
                        parameters: TitleParameters(controller: context.read<TopicFormCubit>().topicTitleController),
                      ),
                      TextFormFieldWidget(
                        parameters: DescriptionParameters(controller: context.read<TopicFormCubit>().topicDescriptionController),
                      ),
                      PostsListViewWidget(
                        isOwner: true,
                        stream: context.read<TopicFormCubit>().postsStreamController.stream,
                      ),
                      TextButtonWidget(
                        onPressed: () async {
                          await context.read<TopicFormCubit>().addPost();
                        },
                        text: 'Add'
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
