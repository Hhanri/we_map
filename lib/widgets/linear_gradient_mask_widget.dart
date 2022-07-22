import 'package:flutter/material.dart';
import 'package:we_map/constants/theme.dart';

class LinearGradientMaskWidget extends StatelessWidget {
  final Widget child;
  const LinearGradientMaskWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppTheme.linearGradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }
}
