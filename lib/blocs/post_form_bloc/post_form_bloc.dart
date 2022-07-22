import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/dialogs/validate_dialog.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';

part 'post_form_event.dart';
part 'post_form_state.dart';

class PostFormBloc extends Bloc<PostFormEvent, PostFormState> {
  final TopicModel parentTopic;
  final BuildContext context;
  final FirebaseFirestoreService firebaseService;
  final FirebaseAuthService authService;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController postTitleController = TextEditingController();
  final TextEditingController postDescriptionController = TextEditingController();

  PostFormBloc({required this.parentTopic, required this.context, required this.firebaseService, required this.authService}) : super(const PostFormInitial(isLoading: false, images: [])) {
    const Uuid uuid = Uuid();
    final ImagePicker picker = ImagePicker();
    List<XFile> images = [];

    Future<void> pickImage({required ImageSource imageSource}) async {
      final XFile? image = await picker.pickImage(source: imageSource);
      if (image != null) {
        images.add(image);
        images = [...images];
      }
    }

    Future<void> tryCatch({required Function function, required bool shouldPop, required Emitter emit}) async {
      emit(PostFormInitial(isLoading: true, images: images));
      try {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        await function();
        emit(PostFormInitial(isLoading: false, images: images));
        shouldPop ? Future.microtask(() => AppRouter.pop()) : null;
      } on FirebaseException catch(error) {
        emit(PostFormInitial(isLoading: false, errorMessage: error.message, images: images));
      }
    }

    Future<void> continueDialog({required String action, required String elementName, required bool shouldPop, required Function function, required Emitter emit}) async{
      final shouldContinue = await showValidateDialog(context: context, action: action, elementName: elementName);
      if (shouldContinue == AppStringsConstants.continueString) {
        await tryCatch(function: function, shouldPop: shouldPop, emit: emit);
      }
    }

    on<DeletePostEvent>((event, emit) {
      AppRouter.pop();
    });

    on<AddPhotoEvent>((event, emit) async {
      await pickImage(imageSource: event.imageSource);
      emit(PostFormInitial(isLoading: false, images: images));
    });

    on<AddPostEvent>((event, emit) async {
      await continueDialog(
        emit: emit,
        action: AppStringsConstants.add,
        elementName: AppStringsConstants.post,
        shouldPop: true,
        function: () async => await firebaseService.setPost(
          post: PostModel(
            uid: authService.getUserId,
            postId: uuid.v4() ,
            parentTopicId: parentTopic.topicId,
            date: DateTime.now(),
            postTitle: postTitleController.text,
            postDescription: postDescriptionController.text
          ),
          images: images
        ),
      );
    });
  }

  @override
  Future<void> close () {
    dateController.dispose();
    postTitleController.dispose();
    postDescriptionController.dispose();
    return super.close();
  }
}
