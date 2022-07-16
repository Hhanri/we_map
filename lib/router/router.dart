import 'package:flutter/scheduler.dart';
import 'package:we_map/models/archive_model.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/pages/archive_form_page.dart';
import 'package:we_map/pages/default_page.dart';
import 'package:we_map/pages/email_verification_page.dart';
import 'package:we_map/pages/home_page.dart';
import 'package:we_map/pages/image_viewer_page.dart';
import 'package:we_map/pages/log_form_page.dart';
import 'package:flutter/material.dart';
import 'package:we_map/pages/signin_page.dart';
import 'package:we_map/pages/signup_page.dart';
import 'package:we_map/screens/loading/loading_screen.dart';

class AppRouter {
  Route onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case defaultRoute: return returnPage(const DefaultPage());
      case signInRoute: return returnPage(const SignInPage());
      case signUpRoute: return returnPage(const SignUpPage());
      case emailVerificationRoute: return returnPage(const EmailVerificationPage());
      case homeRoute: return returnPage(const HomePage());
      case logFormRoute: return returnPage(LogFormPage(initialLog: settings.arguments as LogModel));
      case archiveFormRoute: return returnPage(ArchiveFormPage(initialArchive: settings.arguments as ArchiveModel));
      case imageViewerRoute: return returnPage(ImageViewerPage(url: settings.arguments as String));
      default: return returnPage(const DefaultPage());
    }
  }

  static const String defaultRoute = '/';
  static const String signInRoute = '/signIn';
  static const String signUpRoute = '/signUp';
  static const String isBannedRoute = '/isBanned';
  static const String emailVerificationRoute = '/emailVerification';
  static const String homeRoute = '/home';
  static const String logFormRoute = '/logForm';
  static const String archiveFormRoute = '/archiveForm';
  static const String imageViewerRoute = '/imageViewer';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  MaterialPageRoute returnPage(Widget child) {
    return MaterialPageRoute(builder: (context) => child);
  }

  static void pushNamedAndReplaceAll(String route) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      LoadingScreen.instance().hide();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(route, (route) => route.isFirst);
    });
  }
  static void pushNamed(String route, {dynamic arguments}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.pushNamed(route, arguments: arguments);
    });
  }
  static void pop() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.pop();
    });
  }
}