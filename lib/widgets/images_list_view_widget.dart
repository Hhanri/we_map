import 'package:fire_hydrant_mapper/models/image_model.dart';
import 'package:fire_hydrant_mapper/widgets/image_widget.dart';
import 'package:fire_hydrant_mapper/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class ImagesListViewWidget extends StatelessWidget {
  final Stream<List<ImageModel>> stream;
  const ImagesListViewWidget({Key? key, required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ImageModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ImageModel> images = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ImageWidget(image:images[index]);
            },
          );
        }
        return const LoadingWidget();
      },
    );
  }
}
