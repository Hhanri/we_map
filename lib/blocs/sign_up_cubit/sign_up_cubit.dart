import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/services/firebase_auth_service.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final FirebaseAuthService authService;
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();
  SignUpCubit({required this.authService, required this.context}) : super(const SignUpInitial(isLoading: false));

  void signUp() {
    if (formKey.currentState!.validate()) {
      tryCatch(() async => await authService.signUp(email: emailController.text, password: passwordController.text));
    }
  }

  Future<void> tryCatch(Function function) async {
    emit(loadingState);
    try {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      await function();
      emit(notLoadingState);
    } on FirebaseAuthException catch (error) {
      emit(SignUpInitial(isLoading: false, errorMessage: error.message));
    }
  }

  final loadingState = const SignUpInitial(isLoading: true);
  final notLoadingState = const SignUpInitial(isLoading: false);

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}
