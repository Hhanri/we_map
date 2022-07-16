import 'package:we_map/blocs/archive_form_cubit/archive_form_cubit.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/form_app_bar.dart';
import 'package:we_map/widgets/images_list_view_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveFormPage extends StatelessWidget {
  final ArchiveModel initialArchive;
  const ArchiveFormPage({Key? key, required this.initialArchive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArchiveFormCubit>(
      create: (context) => ArchiveFormCubit(
        context: context,
        initialArchive: initialArchive,
        firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context),
        authService: RepositoryProvider.of<FirebaseAuthService>(context)
      )..init(),
      child: BlocConsumer<ArchiveFormCubit, ArchiveFormState>(
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
                context.read<ArchiveFormCubit>().deleteArchive();
              },
              onValidate: () {
                context.read<ArchiveFormCubit>().editArchive();
              },
            ),
            body: Padding(
              padding: DisplayConstants.scaffoldPadding,
              child: Form(
                key: context.read<ArchiveFormCubit>().formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DatePickerTextFieldWidget(
                        controller: context.read<ArchiveFormCubit>().dateController,
                        onTap: () async {
                          await context.read<ArchiveFormCubit>().pickDateTime();
                        }
                      ),
                      TextFormFieldWidget(
                        parameters: WaterLevelParameters(controller: context.read<ArchiveFormCubit>().waterLevelController)
                      ),
                      TextFormFieldWidget(
                        parameters: NoteParameters(controller: context.read<ArchiveFormCubit>().noteController)
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width*0.5,
                        child: ImagesListViewWidget(
                          isEditing: true,
                          stream: context.read<ArchiveFormCubit>().imagesStreamController.stream,
                        ),
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
