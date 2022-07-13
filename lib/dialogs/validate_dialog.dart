import 'package:flutter/material.dart';
import 'package:we_map/router/router.dart';

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
              AppRouter.navigatorKey.currentState!.pop();
            },
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              AppRouter.navigatorKey.currentState!.pop('continue');
            },
            child: const Text('OK')
          )
        ],
      );
    },
  );
}