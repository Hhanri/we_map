import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/new_archive_form_cubit/new_archive_form_cubit.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class NewArchiveFormPage extends StatelessWidget {
  final LogModel parentLog;
  const NewArchiveFormPage({Key? key, required this.parentLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewArchiveFormCubit>(
      create: (context) => NewArchiveFormCubit(
          context: context,
          firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context),
          authService: RepositoryProvider.of<FirebaseAuthService>(context),
          parentLog: parentLog
      ),
      child: BlocConsumer<NewArchiveFormCubit, NewArchiveFormState>(
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
          return Scaffold(
            appBar: FormAppBarWidget(
              onDelete: () {
                context.read<NewArchiveFormCubit>().deleteArchive();
              },
              onValidate: () {
                context.read<NewArchiveFormCubit>().addArchive();
              },
            ),
            body: Padding(
              padding: DisplayConstants.scaffoldPadding,
              child: Form(
                key: context.read<NewArchiveFormCubit>().formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormFieldWidget(
                        parameters: WaterLevelParameters(controller: context.read<NewArchiveFormCubit>().waterLevelController)
                      ),
                      TextFormFieldWidget(
                        parameters: NoteParameters(controller: context.read<NewArchiveFormCubit>().noteController)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
