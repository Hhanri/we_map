import 'package:we_map/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:we_map/dialogs/error_dialog.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/screens/loading/loading_screen.dart';
import 'package:we_map/services/firebase_service.dart';
import 'package:we_map/widgets/archives_list_view_widget.dart';
import 'package:we_map/widgets/form_app_bar.dart';
import 'package:we_map/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogFormPage extends StatelessWidget {
  final LogModel initialLog;
  const LogFormPage({Key? key, required this.initialLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocProvider<LogFormCubit>(
      create: (context) => LogFormCubit(
        context: context,
        initialLog: initialLog,
        firebaseService: RepositoryProvider.of<FirebaseService>(context)
      )..init(),
      child: BlocConsumer<LogFormCubit, LogFormState>(
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
                context.read<LogFormCubit>().deleteLog();
              },
              onValidate: () {
                if (formKey.currentState!.validate()) {
                  context.read<LogFormCubit>().editLog();
                }
              },
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormFieldWidget(
                      parameters: StreetNameParameters(controller: context.read<LogFormCubit>().streetNameController),
                    ),
                    TextFormFieldWidget(
                      parameters: LatitudeParameters(controller: context.read<LogFormCubit>().latitudeController),
                    ),
                    TextFormFieldWidget(
                      parameters: LongitudeParameters(controller: context.read<LogFormCubit>().longitudeController),
                    ),
                    const Expanded(child: ArchivesListViewWidget()),
                    TextButton(
                      onPressed: () async {
                        await context.read<LogFormCubit>().addArchive();
                      },
                      child: const Text('add')
                    )
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
