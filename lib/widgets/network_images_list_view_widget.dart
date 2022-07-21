import 'package:we_map/models/image_model.dart';
import 'package:we_map/widgets/image_widget.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class NetworkImagesListViewWidget extends StatelessWidget {
  final Stream<List<ImageModel>> stream;
  const NetworkImagesListViewWidget({Key? key, required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ImageModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<ImageModel> images = snapshot.data!;
          final int itemCount = images.length;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width*0.5,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return NetworkImageWidget(image: images[index],);
            }
          );
        }
        return const LoadingWidget();
      },
    );
  }
}
