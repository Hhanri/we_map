import 'package:fire_hydrant_mapper/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:fire_hydrant_mapper/models/archive_model.dart';
import 'package:fire_hydrant_mapper/widgets/archive_list_tile_widget.dart';
import 'package:fire_hydrant_mapper/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivesListViewWidget extends StatelessWidget {
  const ArchivesListViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ArchiveModel>>(
      stream: context.read<LogFormCubit>().archivesStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ArchiveModel archive = snapshot.data![index];
              return ArchiveListTileWidget(archive: archive);
            }
          );
        }
        return const LoadingWidget();
      },
    );
  }
}
