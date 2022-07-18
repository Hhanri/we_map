import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/utils/extensions.dart';
import 'package:we_map/widgets/images_list_view_widget.dart';

class ArchiveViewPage extends StatelessWidget {
  final ArchiveModel archive;
  const ArchiveViewPage({Key? key, required this.archive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: DisplayConstants.scaffoldPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: const Text('Date'),
                trailing: Text(archive.date.formatDate()),
              ),
              ListTile(
                title: const Text('Water Level'),
                trailing: Text(archive.waterLevel.toStringAsFixed(2)),
              ),
              ListTile(
                title: const Text('Note'),
                subtitle: Text(archive.note,),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width*0.5,
                child: ImagesListViewWidget(
                  stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getImagesStream(archive: archive),
                  isEditing: false
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
