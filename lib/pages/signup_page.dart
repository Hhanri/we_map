import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              //context.read<AuthBloc>().add(event)
            },
            child: const Text('sign up'),
          )
        ],
      ),
    );
  }
}
