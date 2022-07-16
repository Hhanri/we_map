import 'package:we_map/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveListTileWidget extends StatelessWidget {
  final ArchiveModel archive;
  final bool isEditing;
  const ArchiveListTileWidget({Key? key, required this.archive, required this.isEditing}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(archive.date.formatDate()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ViewArchiveButton(archive: archive,),
          if (isEditing) EditArchiveButton(archive: archive,),
          if (isEditing) DeleteArchiveButton(archiveId: archive.archiveId)
        ],
      )
    );
  }
}

class ViewArchiveButton extends StatelessWidget {
  final ArchiveModel archive;
  const ViewArchiveButton({Key? key, required this.archive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        AppRouter.pushNamed(AppRouter.archiveViewRoute, arguments: archive);
      },
      icon: const Icon(Icons.remove_red_eye),
    );
  }
}

class EditArchiveButton extends StatelessWidget {
  final ArchiveModel archive;
  const EditArchiveButton({Key? key, required this.archive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        AppRouter.pushNamed(AppRouter.archiveFormRoute, arguments: archive);
      },
      icon: const Icon(Icons.edit),
    );
  }
}

class DeleteArchiveButton extends StatelessWidget {
  final String archiveId;
  const DeleteArchiveButton({Key? key, required this.archiveId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<LogFormCubit>().deleteArchive(archiveId);
      },
      icon: const Icon(Icons.delete),
    );
  }
}

