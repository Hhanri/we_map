import 'package:we_map/blocs/log_form_cubit/log_form_cubit.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/widgets/archive_list_tile_widget.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivesListViewWidget extends StatelessWidget {
  final bool isEditing;
  final Stream<List<ArchiveModel>> stream;
  const ArchivesListViewWidget({Key? key, required this.isEditing, required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ArchiveModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ArchiveModel archive = snapshot.data![index];
              return ArchiveListTileWidget(archive: archive, isEditing: isEditing);
            }
          );
        }
        return const LoadingWidget();
      },
    );
  }
}
