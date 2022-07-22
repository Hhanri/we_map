import 'package:flutter/material.dart';
import 'package:we_map/constants/theme.dart';
import 'package:we_map/widgets/linear_gradient_mask_widget.dart';

class WhiteIconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const WhiteIconButtonWidget({Key? key, required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: AppTheme.backgroundColor,
      onPressed: onPressed,
      icon: Icon(icon)
    );
  }
}

class GradientButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const GradientButtonWidget({Key? key, required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearGradientMaskWidget(
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon)
      ),
    );
  }
}
