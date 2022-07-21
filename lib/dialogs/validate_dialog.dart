import 'package:flutter/material.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/widgets/text_button_widget.dart';

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
          TextButtonWidget(
            onPressed: () {
              AppRouter.pop();
            },
            text: 'Cancel'
          ),
          TextButtonWidget(
            onPressed: () {
              AppRouter.pop('continue');
            },
            text: 'OK'
          )
        ],
      );
    },
  );
}