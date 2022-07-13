import 'package:fire_hydrant_mapper/models/archive_model.dart';
import 'package:fire_hydrant_mapper/models/log_model.dart';
import 'package:fire_hydrant_mapper/pages/archive_form_page.dart';
import 'package:fire_hydrant_mapper/pages/home_page.dart';
import 'package:fire_hydrant_mapper/pages/image_viewer_page.dart';
import 'package:fire_hydrant_mapper/pages/log_form_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute: return returnPage(const HomePage());
      case logFormRoute: return returnPage(LogFormPage(initialLog: settings.arguments as LogModel));
      case archiveFormRoute: return returnPage(ArchiveFormPage(initialArchive: settings.arguments as ArchiveModel));
      case imageViewerROute: return returnPage(ImageViewerPage(url: settings.arguments as String));
      default: return returnPage(const HomePage());
    }
  }

  static const homeRoute = '/home';
  static const logFormRoute = '/logForm';
  static const archiveFormRoute = '/archiveForm';
  static const imageViewerROute = '/imageViewer';

  MaterialPageRoute returnPage(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}