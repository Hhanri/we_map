import 'package:flutter/material.dart';
import 'package:we_map/constants/theme.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const ElevatedButtonWidget({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const EdgeInsets padding = EdgeInsets.all(20);
    return Container(
      height: 44,
      margin: padding,
      decoration: const BoxDecoration(
        gradient: AppTheme.linearGradient,
        borderRadius: DisplayConstants.circularBorderRadius
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: DisplayConstants.circularBorderRadius)
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline5,
        )
      ),
    );
  }
}
