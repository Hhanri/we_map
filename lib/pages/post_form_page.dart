import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/post_form_bloc/post_form_bloc.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/local_images_list_view_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class PostFormPage extends StatelessWidget {
  final TopicModel parentTopic;
  const PostFormPage({Key? key, required this.parentTopic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostFormBloc>(
      create: (context) => PostFormBloc(
          context: context,
          firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context),
          authService: RepositoryProvider.of<FirebaseAuthService>(context),
          parentTopic: parentTopic
      ),
      child: BlocConsumer<PostFormBloc, PostFormState>(
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
              text: AppStringsConstants.postTitle,
              onDelete: () {
                context.read<PostFormBloc>().add(DeletePostEvent());
              },
              onValidate: () {
                context.read<PostFormBloc>().add(AddPostEvent());
              },
            ),
            body: Padding(
              padding: DisplayConstants.scaffoldPadding,
              child: Form(
                key: context.read<PostFormBloc>().formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormFieldWidget(
                        parameters: TitleParameters(controller: context.read<PostFormBloc>().postTitleController)
                      ),
                      TextFormFieldWidget(
                        parameters: DescriptionParameters(controller: context.read<PostFormBloc>().postDescriptionController)
                      ),
                      LocalImagesListViewWidget(images: (state as PostFormInitial).images)
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
