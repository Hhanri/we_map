import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget {
  final String url;
  const ImageViewerPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

      ),
      body: Hero(
        tag: url,
        child: InteractiveViewer(
          child: Center(
            child: CachedNetworkImage(
                imageUrl: url,
              fit: BoxFit.cover,
            )
          ),
        ),
      )
    );
  }
}
