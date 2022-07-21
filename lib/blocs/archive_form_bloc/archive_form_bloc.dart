import 'dart:async';

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

part 'archive_form_event.dart';
part 'archive_form_state.dart';

class ArchiveFormBloc extends Bloc<ArchiveFormEvent, ArchiveFormState> {
  final LogModel parentLog;
  final BuildContext context;
  final FirebaseFirestoreService firebaseService;
  final FirebaseAuthService authService;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController waterLevelController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  ArchiveFormBloc({required this.parentLog, required this.context, required this.firebaseService, required this.authService}) : super(const ArchiveFormInitial(isLoading: false, images: [])) {

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
      emit(ArchiveFormInitial(isLoading: true, images: images));
      try {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        await function();
        emit(ArchiveFormInitial(isLoading: false, images: images));
        shouldPop ? Future.microtask(() => AppRouter.pop()) : null;
      } on FirebaseException catch(error) {
        emit(ArchiveFormInitial(isLoading: false, errorMessage: error.message, images: images));
      }
    }

    Future<void> continueDialog({required String action, required String elementName, required bool shouldPop, required Function function, required Emitter emit}) async{
      final shouldContinue = await showValidateDialog(context: context, action: action, elementName: elementName);
      if (shouldContinue == 'continue') {
        await tryCatch(function: function, shouldPop: shouldPop, emit: emit);
      }
    }

    on<DeleteArchiveEvent>((event, emit) {
      AppRouter.pop();
    });

    on<AddPhotoEvent>((event, emit) async {
      await pickImage(imageSource: event.imageSource);
      emit(ArchiveFormInitial(isLoading: false, images: images));
    });

    on<AddArchiveEvent>((event, emit) async {
      await continueDialog(
        emit: emit,
        action: 'add',
        elementName: 'archive',
        shouldPop: true,
        function: () async => await firebaseService.setArchive(
          archive: ArchiveModel(
            archiveUid: authService.getUserId,
            archiveId: UniqueKey().toString() ,
            parentLogUid: parentLog.logUid,
            parentLogId: parentLog.logId,
            date: DateTime.now(),
            waterLevel: double.tryParse(waterLevelController.text) ?? 0.0,
            note: noteController.text
          ),
          images: images
        ),
      );
    });
  }

  @override
  Future<void> close () {
    dateController.dispose();
    waterLevelController.dispose();
    noteController.dispose();
    return super.close();
  }
}
