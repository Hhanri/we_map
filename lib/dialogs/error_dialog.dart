import 'package:we_map/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorMessage({
  required String errorMessage,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: "error",
    content: errorMessage,
  );
}