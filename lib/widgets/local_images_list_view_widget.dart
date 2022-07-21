import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_map/blocs/archive_form_bloc/archive_form_bloc.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class LocalImagesListViewWidget extends StatelessWidget {
  final List<XFile> images;
  const LocalImagesListViewWidget({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int itemCount = images.length + 1;
    final double size = MediaQuery.of(context).size.width*0.5;
    return SizedBox(
      height: size,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemExtent: size,
        itemCount: itemCount,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == itemCount - 1) {
            return const AddPhotoButtonWidget();
          } else {
            return LocalImageWidget(
              imagePath: images[index].path,
            );
          }
        },
      ),
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
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          borderRadius: DisplayConstants.circularBorderRadius,
          color: AppTheme.placeholderColor,
        ),
        width: 100,
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 24, color: AppTheme.secondaryColor,),
            Text('add photo', style: Theme.of(context).textTheme.headline5,)
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
              context.read<ArchiveFormBloc>().add(AddPhotoEvent(imageSource: imageSource));
            },
            icon: Icon(icon),
            label: Text(label)
          ),
        ),
      ],
    );
  }
}
