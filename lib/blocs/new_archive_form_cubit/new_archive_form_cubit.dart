import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_map/dialogs/validate_dialog.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';

part 'new_archive_form_state.dart';

class NewArchiveFormCubit extends Cubit<NewArchiveFormState> {
  final LogModel parentLog;
  final BuildContext context;
  final FirebaseFirestoreService firebaseService;
  final FirebaseAuthService authService;
  NewArchiveFormCubit({required this.context, required this.firebaseService, required this.authService, required this.parentLog}) : super(const NewArchiveFormInitial(isLoading: false));

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController waterLevelController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final ImagePicker picker = ImagePicker();


  void deleteArchive() {
    AppRouter.pop();
  }

  void addArchive() {
    continueDialog(
      action: 'add',
      elementName: 'archive',
      shouldPop: true,
      function: () async => await firebaseService.setArchive(
        ArchiveModel(
          archiveUid: authService.getUserId,
          archiveId: UniqueKey().toString() ,
          parentLogUid: parentLog.logUid,
          parentLogId: parentLog.logId,
          date: DateTime.now(),
          waterLevel: double.tryParse(waterLevelController.text) ?? 0.0,
          note: noteController.text
        )
      )
    );
  }

  final loadingState = const NewArchiveFormInitial(isLoading: true);
  final notLoadingState = const NewArchiveFormInitial(isLoading: false);

  void emitErrorState(FirebaseException error) {
    emit(NewArchiveFormInitial(isLoading: false, errorMessage: error.message));
  }

  Future<void> tryCatch({required Function function, required bool shouldPop}) async {
    emit(loadingState);
    try {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      await function();
      emit(notLoadingState);
      shouldPop ? Future.microtask(() => AppRouter.pop()) : null;
    } on FirebaseException catch(error) {
      emit(NewArchiveFormInitial(isLoading: false, errorMessage: error.message));
    }
  }
  Future<void> continueDialog({required String action, required String elementName, required bool shouldPop, required Function function}) async{
    final shouldContinue = await showValidateDialog(context: context, action: action, elementName: elementName);
    if (shouldContinue == 'continue') {
      await tryCatch(function: function, shouldPop: shouldPop);
    }
  }

  @override
  Future<void> close () {
    dateController.dispose();
    waterLevelController.dispose();
    noteController.dispose();
    return super.close();
  }
}
