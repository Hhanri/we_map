import 'package:flutter/material.dart';
import 'package:we_map/widgets/linear_gradient_mask_widget.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const TextButtonWidget({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: LinearGradientMaskWidget(
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      )
    );
  }
}
