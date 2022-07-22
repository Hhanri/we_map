import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/create_user_profile_cubit/create_user_profile_cubit.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/elevated_button_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class CreateUserProfilePage extends StatelessWidget {
  const CreateUserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateUserProfileCubit>(
      create: (context) => CreateUserProfileCubit(authService: RepositoryProvider.of<FirebaseAuthService>(context)),
      child: BlocConsumer<CreateUserProfileCubit, CreateUserProfileState>(
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
          return Scaffold(
            appBar: const DefaultAppBarWidget(automaticallyImplyLeading: false,),
            body: Padding(
              padding: DisplayConstants.scaffoldPadding,
              child: Form(
                key: context.read<CreateUserProfileCubit>().formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormFieldWidget(parameters: UsernameParameters(controller: context.read<CreateUserProfileCubit>().usernameController)),
                    ElevatedButtonWidget(text: AppStringsConstants.createProfile, onPressed: () => context.read<CreateUserProfileCubit>().createProfile())
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
