import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/sign_in_cubit/sign_in_state.dart';
import 'package:we_map/router/router.dart';

import 'package:we_map/services/firebase_auth_service.dart';


class SignInCubit extends Cubit<SignInState> {
  final FirebaseAuthService authService;
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  SignInCubit({required this.authService, required this.context}) : super(const SignInInitial(isLoading: false));

  void signIn() async {
    if (formKey.currentState!.validate()) {
      await tryCatch(() async {
        await authService.signIn(email: emailController.text, password: passwordController.text);
        AppRouter.pushNamedAndReplaceAll(AppRouter.homeRoute);
      });
    }
  }

  Future<void> tryCatch(Function function) async {
    emit(loadingState);
    try {
      await function();
      emit(notLoadingState);
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    } on FirebaseAuthException catch (error) {
      emit(SignInInitial(isLoading: false, errorMessage: error.message));
    }
  }

  final loadingState = const SignInInitial(isLoading: true);
  final notLoadingState = const SignInInitial(isLoading: false);

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
