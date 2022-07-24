import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_map/blocs/auth_bloc/auth_bloc.dart';
import 'package:we_map/pages/email_verification_page.dart';
import 'package:we_map/pages/map_page.dart';
import 'package:we_map/pages/signin_page.dart';
import 'package:we_map/pages/signup_page.dart';
import 'package:we_map/screens/loading/loading_screen.dart';

class DefaultRouterPage extends StatelessWidget {
  const DefaultRouterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<AuthState>(
      state: context.select((AuthBloc bloc) => bloc.state),
      onGeneratePages: onGenerateDefaultPages
    );
  }
}

List<Page> onGenerateDefaultPages(AuthState state, List<Page<dynamic>> pages) {
  switch (state) {
    case AuthSignedInState(): return [MapPage.route()];
    case AuthSignedOutState(): return [SignInPage.route()];
    case AuthSigningUpState(): return [SignUpPage.route()];
    case EmailNotVerifiedState(): LoadingScreen.instance().hide(); return [EmailVerificationPage.route()];
    default: return [MapPage.route()];
  }
}