import 'package:flutter/material.dart';

Future<T?> showValidateDialog<T>({
  required BuildContext context,
  required String action,
  required String elementName,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: Text('You are about to $action the $elementName'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('continue');
            },
            child: const Text('OK')
          )
        ],
      );
    },
  );
}