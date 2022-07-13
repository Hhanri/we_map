import 'package:flutter/material.dart';

class FormAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final VoidCallback onValidate;
  final VoidCallback onDelete;
  const FormAppBarWidget({Key? key, required this.onValidate, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
