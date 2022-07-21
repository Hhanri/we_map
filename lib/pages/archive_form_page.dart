import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/archive_form_bloc/archive_form_bloc.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_auth_service.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/local_images_list_view_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';

class ArchiveFormPage extends StatelessWidget {
  final LogModel parentLog;
  const ArchiveFormPage({Key? key, required this.parentLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArchiveFormBloc>(
      create: (context) => ArchiveFormBloc(
          context: context,
          firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context),
          authService: RepositoryProvider.of<FirebaseAuthService>(context),
          parentLog: parentLog
      ),
      child: BlocConsumer<ArchiveFormBloc, ArchiveFormState>(
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
                context.read<ArchiveFormBloc>().add(DeleteArchiveEvent());
              },
              onValidate: () {
                context.read<ArchiveFormBloc>().add(AddArchiveEvent());
              },
            ),
            body: Padding(
              padding: DisplayConstants.scaffoldPadding,
              child: Form(
                key: context.read<ArchiveFormBloc>().formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormFieldWidget(
                        parameters: WaterLevelParameters(controller: context.read<ArchiveFormBloc>().waterLevelController)
                      ),
                      TextFormFieldWidget(
                        parameters: NoteParameters(controller: context.read<ArchiveFormBloc>().noteController)
                      ),
                      LocalImagesListViewWidget(images: (state as ArchiveFormInitial).images)
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
