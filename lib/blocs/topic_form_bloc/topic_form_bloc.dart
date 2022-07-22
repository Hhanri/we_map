import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/dialogs/validate_dialog.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';

part 'topic_form_event.dart';
part 'topic_form_state.dart';

class TopicFormBloc extends Bloc<TopicFormEvent, TopicFormState> {
  final BuildContext context;
  final FirebaseAuthService authService;
  final FirebaseFirestoreService firebaseService;
  TopicModel initialTopic;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController topicTitleController = TextEditingController();
  final TextEditingController topicDescriptionController = TextEditingController();
  TopicFormBloc({required this.context, required this.initialTopic, required this.authService, required this.firebaseService}) : super(const TopicFormViewState(isLoading: false)) {

    Future<void> tryCatch({required Function function, required bool shouldPop, required TopicFormState currentState}) async {
      (currentState is TopicFormViewState) ? add(EmitViewingState(isLoading: true)) : add(EmitEditingState(isLoading: true));
      try {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        await function();
        add(EmitViewingState(isLoading: false));
        shouldPop ? Future.microtask(() => AppRouter.pop()) : null;
      } on FirebaseException catch(error) {
        (currentState is TopicFormViewState) ? add(EmitViewingState(isLoading: false, errorMessage: error.message ?? error.code)) : add(EmitEditingState(isLoading: false, errorMessage: error.message ?? error.code));
      }
    }

    Future<void> continueDialog({required String action, required String elementName, required bool shouldPop, required Function function, required TopicFormState currentState}) async{
      final shouldContinue = await showValidateDialog(context: context, action: action, elementName: elementName);
      if (shouldContinue == AppStringsConstants.continueString) {
        await tryCatch(function: function, shouldPop: shouldPop, currentState: currentState);
      }
    }

    on<EditTopicEvent>((event, emit) {
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
        currentState: event.currentState,
        function: () async {
          await firebaseService.updateTopic(oldTopic: initialTopic, newTopic: newTopic).then((value) {
            initialTopic = newTopic;
            add(EmitViewingState(isLoading: false));
          });
        }
      );
    });

    on<DeleteTopicEvent>((event, emit) {
      continueDialog(
        action: AppStringsConstants.delete,
        elementName: AppStringsConstants.topic,
        shouldPop: true,
        currentState: const TopicFormViewState(isLoading: false),
        function: () async => await firebaseService.deleteTopic(topic: initialTopic)
      );
    });

    on<AddPostEvent>((event, emit) {
      AppRouter.pushNamed(AppRouter.postFormRoute, arguments: initialTopic);
    });
    
    on<DeletePostEvent>((event, emit) {
      continueDialog(
        action: AppStringsConstants.delete,
        elementName: AppStringsConstants.post,
        shouldPop: false,
        currentState: const TopicFormViewState(isLoading: false),
        function: () async => await firebaseService.deletePost(post: event.post)
      );
    });

    on<EmitEditingState> ((event, emit) {
      topicTitleController.text = initialTopic.topicTitle;
      topicDescriptionController.text = initialTopic.topicDescription;
      emit(TopicFormEditState(isLoading: event.isLoading, errorMessage: event.errorMessage));
    });

    on<EmitViewingState>((event, emit) {
      emit(TopicFormViewState(isLoading: event.isLoading, errorMessage: event.errorMessage));
    });
  }
  @override
  Future<void> close () {
    topicTitleController.dispose();
    topicDescriptionController.dispose();
    return super.close();
  }
}
