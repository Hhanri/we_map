import 'package:cached_network_image/cached_network_image.dart';
import 'package:we_map/blocs/archive_form_cubit/archive_form_cubit.dart';
import 'package:we_map/models/image_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/services/firebase_firestore_service.dart';
import 'package:we_map/widgets/squared_icon_button_widget.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageWidget extends StatelessWidget {
  final ImageModel image;
  final bool isEditing;
  const ImageWidget({Key? key, required this.image, required this.isEditing}) : super(key: key);

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
                    AppRouter.pushNamed(AppRouter.imageViewerRoute, arguments: url);
                  },
                  child: Hero(
                    tag: url,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: url,
                      placeholder: (context, _) => const LoadingWidget(),
                    ),
                  ),
                );
              }
              return const LoadingWidget();
            }
          ),
        ),
        if (isEditing) Positioned(
          top: 0,
          right: 0,
          child: SquaredIconButtonWidget(
            onTap: () {
              context.read<ArchiveFormCubit>().deleteImage(image);
            },
            icon: Icons.delete)
        )
      ],
    );
  }
}
