import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/services/firebase_auth_service.dart';

part 'create_user_profile_state.dart';

class CreateUserProfileCubit extends Cubit<CreateUserProfileState> {
  final FirebaseAuthService authService;
  CreateUserProfileCubit({required this.authService}) : super(const CreateUserProfileInitial(isLoading: false));

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();

  void createProfile() {
    if (formKey.currentState!.validate()) {
      tryCatch(() async => await authService.createProfile(username: usernameController.text));
    }
  }

  Future<void> tryCatch(Function function) async {
    emit(loadingState);
    try {
      await function();
      emit(notLoadingState);
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    } on FirebaseAuthException catch (error) {
      emit(CreateUserProfileInitial(isLoading: false, errorMessage: error.message));
    }
  }

  final loadingState = const CreateUserProfileInitial(isLoading: true);
  final notLoadingState = const CreateUserProfileInitial(isLoading: false);

  @override
  Future<void> close() {
    usernameController.dispose();
    return super.close();
  }
}
