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
      padding: EdgeInsets.zero,
      color: AppTheme.secondaryColor,
      onPressed: () {
        print("LIKE !");
        onPressed();
      },
      icon: Icon(
        icon,
        size: 42,
      )
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
      child: WhiteIconButtonWidget(
        onPressed: onPressed,
        icon: icon
      ),
    );
  }
}
