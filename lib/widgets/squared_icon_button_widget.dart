import 'package:flutter/material.dart';

class SquaredIconButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const SquaredIconButtonWidget({Key? key, required this.onTap, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.black54,
        height: 40,
        width: 40,
        child: Icon(icon, color: Colors.white,),
      ),
    );
  }
}
