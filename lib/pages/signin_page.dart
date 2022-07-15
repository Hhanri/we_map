import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/sign_in_cubit/sign_in_cubit.dart';
import 'package:we_map/blocs/sign_in_cubit/sign_in_state.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: BlocProvider(
          create: (context) => SignInCubit(authService: context.read<FirebaseAuthService>(), context: context)..initTest(),
          child: BlocConsumer<SignInCubit, SignInState>(
            listener: (context, state) {
              if (state.isLoading) {
                LoadingScreen.instance().show(
                    context: context, text: 'loading...');
              } else {
                LoadingScreen.instance().hide();
              }
              if (state.errorMessage != null) {
                showErrorMessage(errorMessage: state.errorMessage!, context: context);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  TextButton(
                    onPressed: () {
                      context.read<SignInCubit>().signIn();
                    },
                    child: const Text('sign in'),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
