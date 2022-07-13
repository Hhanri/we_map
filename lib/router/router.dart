import 'package:we_map/models/archive_model.dart';
import 'package:we_map/models/log_model.dart';
import 'package:we_map/pages/archive_form_page.dart';
import 'package:we_map/pages/default_page.dart';
import 'package:we_map/pages/home_page.dart';
import 'package:we_map/pages/image_viewer_page.dart';
import 'package:we_map/pages/log_form_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute: return returnPage(const HomePage());
      case logFormRoute: return returnPage(LogFormPage(initialLog: settings.arguments as LogModel));
      case archiveFormRoute: return returnPage(ArchiveFormPage(initialArchive: settings.arguments as ArchiveModel));
      case imageViewerRoute: return returnPage(ImageViewerPage(url: settings.arguments as String));
      default: return returnPage(const DefaultPage());
    }
  }

  static const String signInRoute = '/signIn';
  static const String signUpRoute = '/signUp';
  static const String isBannedRoute = '/isBanned';
  static const String emailConfirmationRoute = '/emailConfirmation';
  static const String homeRoute = '/home';
  static const String logFormRoute = '/logForm';
  static const String archiveFormRoute = '/archiveForm';
  static const String imageViewerRoute = '/imageViewer';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  MaterialPageRoute returnPage(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }

  static Future pushNamedAndReplaceAll(String route) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(route, (route) => false);
  }
}