import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/app_bar_widget.dart';
import 'package:we_map/widgets/archives_list_view_widget.dart';

class LogViewPage extends StatelessWidget {
  final LogModel log;
  const LogViewPage({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBarWidget(),
      body: Padding(
        padding: DisplayConstants.scaffoldPadding,
        child: Column(
          children: [
            ListTile(
              title: const Text('Street Name'),
              trailing: Text(log.streetName),
            ),
            ListTile(
              title: const Text('Geopoint'),
              trailing: FittedBox(child: Text("[${log.geoPoint.latitude.toStringAsFixed(5)}, ${log.geoPoint.longitude.toStringAsFixed(5)}]")),
            ),
            Expanded(
              child: ArchivesListViewWidget(
                isOwner: false,
                stream: RepositoryProvider.of<FirebaseFirestoreService>(context).getArchivesStream(log: log)
              ),
            )
          ],
        ),
      ),
    );
  }
}
