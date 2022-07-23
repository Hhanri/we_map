import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/auth_bloc/auth_bloc.dart';
import 'package:we_map/blocs/sign_up_cubit/sign_up_cubit.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/widgets/elevated_button_widget.dart';
import 'package:we_map/widgets/text_button_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Page route() => const MaterialPage<void>(child: SignUpPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignUpCubit>(
        create: (context) => SignUpCubit(authService: RepositoryProvider.of<FirebaseAuthService>(context), context: context),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(context: context, text: AppStringsConstants.loading);
            } else {
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
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        TextFormFieldWidget(
                          parameters: UsernameParameters(controller: context.read<SignUpCubit>().usernameController)
                        ),
                        TextFormFieldWidget(
                          parameters: EmailParameters(controller: context.read<SignUpCubit>().emailController),
                        ),
                        TextFormFieldWidget(
                          parameters: PasswordParameters(controller: context.read<SignUpCubit>().passwordController),
                        ),
                        TextFormFieldWidget(
                          parameters: PasswordConfirmationParameters(mainController: context.read<SignUpCubit>().passwordController, confirmationController: context.read<SignUpCubit>().passwordConfirmationController),
                        ),
                        ElevatedButtonWidget(
                          onPressed: () {
                            context.read<SignUpCubit>().signUp();
                          },
                          text: AppStringsConstants.signUp,
                        ),
                        const Spacer(),
                        TextButtonWidget(
                          onPressed: () {
                            context.read<AuthBloc>().add(EmitSignedOutEvent());
                          },
                          text: AppStringsConstants.signIn
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
