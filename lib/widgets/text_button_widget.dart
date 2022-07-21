import 'package:flutter/material.dart';
import 'package:we_map/constants/theme.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const TextButtonWidget({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: ShaderMask(
        shaderCallback: (bounds) => AppTheme.linearGradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      )
    );
  }
}
