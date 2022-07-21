import 'package:flutter/material.dart';
import 'package:we_map/router/router.dart';
import 'package:we_map/widgets/text_button_widget.dart';

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
          TextButtonWidget(
            onPressed: () {
              AppRouter.pop();
            },
            text: 'OK',
          )
        ],
      );
    },
  );
}