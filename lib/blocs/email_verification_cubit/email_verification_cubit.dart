import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/services/firebase_auth_service.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final FirebaseAuthService authService;
  EmailVerificationCubit({required this.authService}) : super(const EmailVerificationInitial(isLoading: false));

  void signOut() {
    tryCatch(() async => await authService.signOut());
  }

  void resendLink() {
    tryCatch(() async => await authService.sendEmailVerification());
  }

  Future<void> tryCatch(Function function) async {
    emit(loadingState);
    try {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      await function();
      emit(notLoadingState);
    } on FirebaseAuthException catch (error) {
      emit(EmailVerificationInitial(isLoading: false, errorMessage: error.message));
    }
  }

  final loadingState = const EmailVerificationInitial(isLoading: true);
  final notLoadingState = const EmailVerificationInitial(isLoading: false);
}
