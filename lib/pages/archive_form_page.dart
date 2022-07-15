import 'package:we_map/blocs/archive_form_cubit/archive_form_cubit.dart';
import 'package:we_map/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/form_app_bar.dart';
import 'package:we_map/widgets/images_list_view_widget.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ArchiveFormPage extends StatelessWidget {
  final ArchiveModel initialArchive;
  const ArchiveFormPage({Key? key, required this.initialArchive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArchiveFormCubit>(
      create: (context) => ArchiveFormCubit(
        context: context,
        initialArchive: initialArchive,
        firebaseService: RepositoryProvider.of<FirebaseFirestoreService>(context)
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
                key: context.read<LogFormCubit>().formKey,
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
                    Expanded(child: ImagesListViewWidget(stream: context.read<ArchiveFormCubit>().imagesStreamController.stream,)),
                    const AddPhotoButtonWidget()
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

class AddPhotoButtonWidget extends StatelessWidget {
  const AddPhotoButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await showModalBottomSheet(
          context: context,
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                innerButton(context: context, imageSource: ImageSource.camera, icon: Icons.photo_camera, label: 'Camera'),
                innerButton(context: context, imageSource: ImageSource.gallery, icon: Icons.photo, label: 'Gallery')
              ],
            );
          }
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Add photo')
    );
  }

  Widget innerButton({required BuildContext context, required ImageSource imageSource, required IconData icon, required String label}) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              AppRouter.navigatorKey.currentState!.pop();
              context.read<ArchiveFormCubit>().pickImage(imageSource: imageSource);
            },
            icon: Icon(icon),
            label: Text(label)
          ),
        ),
      ],
    );
  }
}
