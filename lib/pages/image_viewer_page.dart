import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageViewerPage extends StatelessWidget {
  final String url;
  const NetworkImageViewerPage({Key? key, required this.url}) : super(key: key);

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

class LocalImageViewerPage extends StatelessWidget {
  final String path;
  const LocalImageViewerPage({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Hero(
        tag: path,
        child: InteractiveViewer(
          child: Center(
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
            )
          ),
        ),
      )
    );
  }
}