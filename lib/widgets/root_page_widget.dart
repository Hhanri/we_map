import 'dart:io';

import 'package:flutter/material.dart';

class RootPageWidget extends StatelessWidget {
  final Widget child;
  const RootPageWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return exit(0);
      },
      child: child,
    );
  }
}
