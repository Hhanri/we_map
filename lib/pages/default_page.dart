import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/auth_bloc/auth_bloc.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authService: RepositoryProvider.of<FirebaseAuthService>(context))..add(AuthInitializeEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        child: const Scaffold(),
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen.instance().show(context: context, text: 'loading...');
          } else {
            LoadingScreen.instance().hide();
          }
          if (state.errorMessage != null) {
            showErrorMessage(errorMessage: state.errorMessage!, context: context);
          }
          if (state is AuthSignedInState) {
            AppRouter.pushNamedAndReplaceAll(AppRouter.homeRoute);
          }
          if (state is AuthSignedOutState) {
            AppRouter.pushNamedAndReplaceAll(AppRouter.signInRoute);
          }
          if (state is AuthBannedState) {
            AppRouter.pushNamedAndReplaceAll(AppRouter.isBannedRoute);
          }
        },
      ),
    );
  }
}
