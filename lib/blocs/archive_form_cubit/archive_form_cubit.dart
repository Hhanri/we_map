import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_hydrant_mapper/dialogs/validate_dialog.dart';
import 'package:fire_hydrant_mapper/models/archive_model.dart';
import 'package:fire_hydrant_mapper/models/image_model.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:fire_hydrant_mapper/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'archive_form_state.dart';

class ArchiveFormCubit extends Cubit<ArchiveFormState> {
  final ArchiveModel initialArchive;
  final FirebaseService firebaseService;
  final BuildContext context;
  final StreamController<List<ImageModel>> imagesStreamController = StreamController<List<ImageModel>>();
  ArchiveFormCubit({required this.initialArchive, required this.firebaseService, required this.context}) : super(const ArchiveFormInitial(isLoading: false));

  late DateTime date;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController waterLevelController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  void init() {
    imagesStreamController.addStream(firebaseService.getImagesStream(parentArchiveId: initialArchive.archiveId));
    date = initialArchive.date;
    dateController.text = initialArchive.date.formatDate();
    waterLevelController.text = initialArchive.waterLevel.toString();
    noteController.text = initialArchive.note;
  }

  void changeDate(DateTime newDate) {
    date = newDate;
    dateController.text = date.formatDate();
  }

  Future<void> pickDateTime() async {
    TimeOfDay? newTime;
    DateTime? newDate;

    newDate = await showDatePicker(
      context: context,
      initialDate: initialArchive.date,
      firstDate: DateTime(1990),
      lastDate: DateTime.now()
    );

    if (newDate != null) {

      newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
      );
    }

    if (newDate != null && newTime != null) {
      changeDate(
        DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute)
      );
    }
  }

  void deleteArchive() {
    continueDialog(
      action: 'delete',
      elementName: 'archive',
      shouldPop: true,
      function: () async => await firebaseService.deleteArchive(archiveId: initialArchive.archiveId)
    );
  }

  void editArchive() {
    final DateTime newDate = date;
    final double newWaterLevel = double.parse(waterLevelController.text);
    final String newNote = noteController.text;

    if (newDate != initialArchive.date
      || newWaterLevel != initialArchive.waterLevel
      || newNote != initialArchive.note
    ) {
      final ArchiveModel newArchiveModel = ArchiveModel(
        parentLogId: initialArchive.parentLogId,
        archiveId: initialArchive.archiveId,
        date: newDate,
        waterLevel: newWaterLevel,
        note: newNote,
      );
      continueDialog(
        action: 'edit',
        elementName: 'archive',
        shouldPop: true,
        function: () async => await firebaseService.updateArchiveWithoutImages(newArchive: newArchiveModel)
      );
    }
  }

  void pickImage({required ImageSource imageSource}) async {
    final XFile? image = await picker.pickImage(source: imageSource);
    if (image == null) return;
    continueDialog(
      action: 'upload',
      elementName: 'image',
      shouldPop: false,
      function: () async => await firebaseService.uploadImage(parentArchiveId: initialArchive.archiveId, image: image)
    );
  }

  Future<String> getImageUrl(ImageModel image) async {
    return firebaseService.downloadURL(image.path);
  }

  void deleteImage(ImageModel image) {
    continueDialog(
      action: 'delete',
      elementName: 'image',
      shouldPop: false,
      function: () async =>await firebaseService.deleteImage(image: image)
    );
  }

  final loadingState = const ArchiveFormInitial(isLoading: true);
  final notLoadingState = const ArchiveFormInitial(isLoading: false);

  void emitErrorState(FirebaseException error) {
    emit(ArchiveFormInitial(isLoading: false, errorMessage: error.message));
  }

  Future<void> tryCatch(Function function) async {
    emit(loadingState);
    try {
      await function();
      emit(notLoadingState);
    } on FirebaseException catch(error) {
      emit(ArchiveFormInitial(isLoading: false, errorMessage: error.message));
    }
  }
  Future<void> continueDialog({required String action, required String elementName, required bool shouldPop, required Function function}) async{
    final shouldContinue = await showValidateDialog(context: context, action: action, elementName: elementName);
    if (shouldContinue == 'continue') {
      await tryCatch(function);
      shouldPop ? Future.microtask(() => Navigator.of(context).pop()) : null;
    }
  }

  @override
  Future<void> close () {
    imagesStreamController.close();
    dateController.dispose();
    waterLevelController.dispose();
    noteController.dispose();
    return super.close();
  }

}
