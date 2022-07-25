import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/auth_bloc/auth_bloc.dart';
import 'package:we_map/constants/app_strings_constants.dart';
import 'package:we_map/constants/theme.dart';

class DefaultAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final bool? automaticallyImplyLeading;
  final Widget? leading;
  final List<Widget>? actions;
  const DefaultAppBarWidget({Key? key, this.title, this.actions, this.automaticallyImplyLeading, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading != null ? automaticallyImplyLeading! : true,
      title: (title != null) ? Text(title!) : null,
      actions: actions,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.linearGradient
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PostFormAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final VoidCallback onValidate;
  final VoidCallback onDelete;
  const PostFormAppBarWidget({Key? key, required this.onValidate, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarWidget(
      title: AppStringsConstants.postTitle,
      actions: [
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete)
        ),
        IconButton(
          onPressed: onValidate,
          icon: const Icon(Icons.check)
        ),
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TopicFormEditingAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final VoidCallback onValidate;
  final VoidCallback onCancel;
  const TopicFormEditingAppBarWidget({Key? key, required this.onValidate, required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarWidget(
      title: AppStringsConstants.topicTitle,
      actions: [
        IconButton(
          onPressed: onCancel,
          icon: const Icon(Icons.close),
        ),
        IconButton(
          onPressed: onValidate,
          icon: const Icon(Icons.check)
        ),
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TopicFormOwnerAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TopicFormOwnerAppBarWidget({Key? key, required this.onEdit, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarWidget(
      title: AppStringsConstants.topicTitle,
      actions: [
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
        ),
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeAppBarWidget extends StatelessWidget with PreferredSizeWidget{
  const HomeAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarWidget(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          context.read<AuthBloc>().authService.signOut();
        },
        icon: const Icon(Icons.logout),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CommentAppBarWidget extends StatelessWidget with PreferredSizeWidget{
  final int number;
  const CommentAppBarWidget({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarWidget(
      automaticallyImplyLeading: true,
      title: "$number comments"
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}