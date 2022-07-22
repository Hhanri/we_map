import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/auth_bloc/auth_bloc.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/widgets/loading_widget.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      child: const Scaffold(
        body: LoadingWidget(),
      ),
      listener: (context, state) {
        if (state is AuthSignedInState) {
          AppRouter.pushNamedAndReplaceAll(AppRouter.homeRoute);
        }
        if (state is ProfileNotExistsState) {
          AppRouter.pushNamedAndReplaceAll(AppRouter.profileNotExists);
        }
        if (state is EmailNotVerifiedState) {
          AppRouter.pushNamedAndReplaceAll(AppRouter.emailVerificationRoute);
        }
        if (state is AuthSignedOutState) {
          AppRouter.pushNamedAndReplaceAll(AppRouter.signInRoute);
        }
        if (state is AuthBannedState) {
          AppRouter.pushNamedAndReplaceAll(AppRouter.isBannedRoute);
        }
      },
    );
  }
}
