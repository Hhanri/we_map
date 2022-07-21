import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_map/dialogs/validate_dialog.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

part 'log_form_state.dart';

class LogFormCubit extends Cubit<LogFormState> {
  final BuildContext context;
  final LogModel initialLog;
  final FirebaseAuthService authService;
  final FirebaseFirestoreService firebaseService;
  final StreamController<List<ArchiveModel>> archivesStreamController = StreamController<List<ArchiveModel>>();
  LogFormCubit({required this.context, required this.initialLog, required this.firebaseService, required this.authService}) : super(const LogFormInitial(isLoading: false));

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void init() {
    streetNameController.text = initialLog.streetName;
    latitudeController.text = initialLog.geoPoint.latitude.toString();
    longitudeController.text = initialLog.geoPoint.longitude.toString();
    archivesStreamController.addStream(firebaseService.getArchivesStream(log: initialLog));
  }

  void editLog() {
    if (!formKey.currentState!.validate()) return;
    final newGeoFirePoint = GeoFirePoint(double.parse(latitudeController.text), double.parse(longitudeController.text));
    final newLogId = newGeoFirePoint.hash;
    final String newStreetName = streetNameController.text;

    final LogModel newLog = LogModel(
      logUid: initialLog.logUid,
      logId: newLogId,
      geoPoint: newGeoFirePoint,
      streetName: newStreetName
    );

    continueDialog(
      action: 'edit',
      elementName: 'log',
      shouldPop: false,
      function: () async => await firebaseService.updateLog(oldLog: initialLog, newLog: newLog)
    );
  }

  void deleteLog() {
    continueDialog(
      action: 'delete',
      elementName: 'log',
      shouldPop: true,
      function: () async => await firebaseService.deleteLog(log: initialLog)
    );
  }

  Future<void> addArchive() async {
    AppRouter.pushNamed(AppRouter.archiveFormRoute, arguments: initialLog);
  }

  void deleteArchive(ArchiveModel archive) {
    continueDialog(
      action: 'delete',
      elementName: 'archive',
      shouldPop: false,
      function: () async => await firebaseService.deleteArchive(archive: archive)
    );
  }

  final loadingState = const LogFormInitial(isLoading: true);
  final notLoadingState = const LogFormInitial(isLoading: false);

  void emitErrorState(FirebaseException error) {
    emit(LogFormInitial(isLoading: false, errorMessage: error.message));
  }

  Future<void> tryCatch({required Function function, required bool shouldPop}) async {
    emit(loadingState);
    try {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      await function();
      emit(notLoadingState);
      shouldPop ? Future.microtask(() => AppRouter.pop()) : null;
    } on FirebaseException catch(error) {
      emit(LogFormInitial(isLoading: false, errorMessage: error.message ?? error.code));
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
    streetNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    archivesStreamController.close();
    return super.close();
  }
}
