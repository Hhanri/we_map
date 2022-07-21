import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/sign_in_cubit/sign_in_cubit.dart';
import 'package:we_map/blocs/sign_in_cubit/sign_in_state.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/widgets/elevated_button_widget.dart';
import 'package:we_map/widgets/root_page_widget.dart';
import 'package:we_map/widgets/text_button_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootPageWidget(
      child: Scaffold(
        body: BlocProvider<SignInCubit>(
          create: (context) => SignInCubit(authService: context.read<FirebaseAuthService>(), context: context),
          child: BlocConsumer<SignInCubit, SignInState>(
            listener: (context, state) {
              if (state.isLoading) {
                LoadingScreen.instance().show(
                    context: context, text: AppStringsConstants.loading);
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
                  key: context.read<SignInCubit>().formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      TextFormFieldWidget(
                        parameters: EmailParameters(controller: context.read<SignInCubit>().emailController),
                      ),
                      TextFormFieldWidget(
                        parameters: PasswordParameters(controller: context.read<SignInCubit>().passwordController),
                      ),
                      ElevatedButtonWidget(
                        text: AppStringsConstants.signIn,
                        onPressed: () {
                          context.read<SignInCubit>().signIn();
                        }
                      ),
                      const Spacer(),
                      TextButtonWidget(
                        onPressed: () {
                          AppRouter.pushNamed(AppRouter.signUpRoute);
                        },
                        text: AppStringsConstants.createAccount
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
