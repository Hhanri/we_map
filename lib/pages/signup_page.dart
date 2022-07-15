import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/sign_up_cubit/sign_up_cubit.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignUpCubit>(
        create: (context) => SignUpCubit(authService: RepositoryProvider.of<FirebaseAuthService>(context), context: context),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(context: context, text: 'loading...');
            } else {
              print("HIDE LOADING SCREEN");
              LoadingScreen.instance().hide();
            }
            if (state.errorMessage != null) {
              showErrorMessage(errorMessage: state.errorMessage!, context: context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: DisplayConstants.scaffoldPadding,
              child: Form(
                key: context.read<SignUpCubit>().formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormFieldWidget(
                      parameters: EmailParameters(controller: context.read<SignUpCubit>().emailController),
                    ),
                    TextFormFieldWidget(
                      parameters: PasswordParameters(controller: context.read<SignUpCubit>().passwordController),
                    ),
                    TextFormFieldWidget(
                      parameters: PasswordConfirmationParameters(mainController: context.read<SignUpCubit>().passwordController, confirmationController: context.read<SignUpCubit>().passwordConfirmationController),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<SignUpCubit>().signUp();
                      },
                      child: const Text('sign up'),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
