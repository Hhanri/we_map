import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/email_verification_cubit/email_verification_cubit.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/widgets/root_page_widget.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootPageWidget(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => EmailVerificationCubit(authService: RepositoryProvider.of<FirebaseAuthService>(context)),
          child: BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
            listener: (context, state) {
              if (state.isLoading) {
                LoadingScreen.instance().show(context: context, text: 'loading...');
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Please click on the link you've received by email to activate your account"),
                    TextButton(
                      onPressed: () {
                        context.read<EmailVerificationCubit>().resendLink();
                      },
                      child: const Text('Resend link'))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
