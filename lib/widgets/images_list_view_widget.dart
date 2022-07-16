import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_map/blocs/archive_form_cubit/archive_form_cubit.dart';
import 'package:we_map/models/image_model.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/widgets/image_widget.dart';
import 'package:we_map/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class ImagesListViewWidget extends StatelessWidget {
  final Stream<List<ImageModel>> stream;
  final bool isEditing;
  const ImagesListViewWidget({Key? key, required this.stream, required this.isEditing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ImageModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<ImageModel> images = snapshot.data!;
          final int itemCount = isEditing ? images.length + 1 : images.length;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width*0.5,
            itemCount: itemCount,
            //shrinkWrap: true,
            itemBuilder: (context, index) {
              if (isEditing == true && index == itemCount - 1) {
                return const AddPhotoButtonWidget();
              } else {
                return ImageWidget(
                  image: images[index],
                  isEditing: isEditing,
                );
              }
            },
          );
        }
        return const LoadingWidget();
      },
    );
  }
}

class AddPhotoButtonWidget extends StatelessWidget {
  const AddPhotoButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                innerButton(context: context, imageSource: ImageSource.camera, icon: Icons.photo_camera, label: 'Camera'),
                innerButton(context: context, imageSource: ImageSource.gallery, icon: Icons.photo, label: 'Gallery')
              ],
            );
          }
        );
      },
      child: Container(
        width: 100,
        height: 100,
        color: Colors.black26,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, size: 24,),
            Text('add photo')
          ],
        ),
      ),
    ) ;
  }

  Widget innerButton({required BuildContext context, required ImageSource imageSource, required IconData icon, required String label}) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              AppRouter.pop();
              context.read<ArchiveFormCubit>().pickImage(imageSource: imageSource);
            },
            icon: Icon(icon),
            label: Text(label)
          ),
        ),
      ],
    );
  }
}
