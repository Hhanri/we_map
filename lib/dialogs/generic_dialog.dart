import 'package:flutter/material.dart';
import 'package:we_map/router/router.dart';

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              AppRouter.pop();
            },
            child: const Text('OK')
          )
        ],
      );
    },
  );
}