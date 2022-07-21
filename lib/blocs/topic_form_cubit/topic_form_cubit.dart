import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/dialogs/validate_dialog.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'topic_form_state.dart';

class TopicFormCubit extends Cubit<TopicFormState> {
  final BuildContext context;
  final TopicModel initialTopic;
  final FirebaseAuthService authService;
  final FirebaseFirestoreService firebaseService;
  final StreamController<List<PostModel>> postsStreamController = StreamController<List<PostModel>>();
  TopicFormCubit({required this.context, required this.initialTopic, required this.firebaseService, required this.authService}) : super(const TopicFormInitial(isLoading: false));

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController topicTitleController = TextEditingController();
  final TextEditingController topicDescriptionController = TextEditingController();

  void init() {
    topicTitleController.text = initialTopic.topicTitle;
    topicDescriptionController.text = initialTopic.topicDescription;
    postsStreamController.addStream(firebaseService.getPostsStream(topic: initialTopic));
  }

  void editTopic() {
    if (!formKey.currentState!.validate()) return;

    final TopicModel newTopic = TopicModel.editedTopic(
      oldTopic: initialTopic,
      newTitle: topicTitleController.text, 
      newDescription: topicDescriptionController.text
    );

    continueDialog(
      action: AppStringsConstants.edit,
      elementName: AppStringsConstants.topic,
      shouldPop: false,
      function: () async => await firebaseService.updateTopic(oldTopic: initialTopic, newTopic: newTopic)
    );
  }

  void deleteTopic() {
    continueDialog(
      action: AppStringsConstants.delete,
      elementName: AppStringsConstants.topic,
      shouldPop: true,
      function: () async => await firebaseService.deleteTopic(topic: initialTopic)
    );
  }

  Future<void> addPost() async {
    AppRouter.pushNamed(AppRouter.postFormRoute, arguments: initialTopic);
  }

  void deletePost(PostModel post) {
    continueDialog(
      action: AppStringsConstants.delete,
      elementName: AppStringsConstants.post,
      shouldPop: false,
      function: () async => await firebaseService.deletePost(post: post)
    );
  }

  final loadingState = const TopicFormInitial(isLoading: true);
  final notLoadingState = const TopicFormInitial(isLoading: false);

  void emitErrorState(FirebaseException error) {
    emit(TopicFormInitial(isLoading: false, errorMessage: error.message));
  }

  Future<void> tryCatch({required Function function, required bool shouldPop}) async {
    emit(loadingState);
    try {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      await function();
      emit(notLoadingState);
      shouldPop ? Future.microtask(() => AppRouter.pop()) : null;
    } on FirebaseException catch(error) {
      emit(TopicFormInitial(isLoading: false, errorMessage: error.message ?? error.code));
    }
  }
  Future<void> continueDialog({required String action, required String elementName, required bool shouldPop, required Function function}) async{
    final shouldContinue = await showValidateDialog(context: context, action: action, elementName: elementName);
    if (shouldContinue == AppStringsConstants.continueString) {
      await tryCatch(function: function, shouldPop: shouldPop);
    }
  }

  @override
  Future<void> close () {
    topicTitleController.dispose();
    topicDescriptionController.dispose();
    postsStreamController.close();
    return super.close();
  }
}
