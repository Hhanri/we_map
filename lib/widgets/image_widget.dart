import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/models/image_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkImageWidget extends StatelessWidget {
  final ImageModel image;
  const NetworkImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width*0.5,
          child: FutureBuilder<String>(
            future: RepositoryProvider.of<FirebaseFirestoreService>(context).downloadURL(image.path),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final String url = snapshot.data!;
                return InkWell(
                  onTap: () {
                    AppRouter.pushNamed(AppRouter.networkImageViewerRoute, arguments: url);
                  },
                  child: Hero(
                    tag: url,
                    child: ClipRRect(
                      borderRadius: DisplayConstants.circularBorderRadius,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: url,
                        placeholder: (context, _) => const LoadingWidget(),
                      ),
                    ),
                  ),
                );
              }
              return const LoadingWidget();
            }
          ),
        ),
      ],
    );
  }
}

class LocalImageWidget extends StatelessWidget {
  final String imagePath;
  const LocalImageWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width*0.5,
          child: InkWell(
            onTap: () {
              AppRouter.pushNamed(AppRouter.localImageViewerRoute, arguments: imagePath);
            },
            child: Hero(
              tag: imagePath,
              child: ClipRRect(
                borderRadius: DisplayConstants.circularBorderRadius,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}

