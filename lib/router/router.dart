import 'package:flutter/scheduler.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/pages/post_view_page.dart';
import 'package:we_map/pages/default_page.dart';
import 'package:we_map/pages/email_verification_page.dart';
import 'package:we_map/pages/home_page.dart';
import 'package:we_map/pages/image_viewer_page.dart';
import 'package:we_map/pages/topic_form_page.dart';
import 'package:flutter/material.dart';
import 'package:we_map/pages/topic_view_page.dart';
import 'package:we_map/pages/post_form_page.dart';
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
      case topicViewRoute: return returnPage(TopicViewPage(topic: settings.arguments as TopicModel));
      case topicFormRoute: return returnPage(TopicFormPage(initialTopic: settings.arguments as TopicModel));
      case postViewRoute: return returnPage(PostViewPage(post: settings.arguments as PostModel));
      case postFormRoute: return returnPage(PostFormPage(parentTopic: settings.arguments as TopicModel));
      case networkImageViewerRoute: return returnPage(NetworkImageViewerPage(url: settings.arguments as String));
      case localImageViewerRoute: return returnPage(LocalImageViewerPage(path: settings.arguments as String));
      default: return returnPage(const DefaultPage());
    }
  }

  static const String defaultRoute = '/';
  static const String signInRoute = '/signIn';
  static const String signUpRoute = '/signUp';
  static const String isBannedRoute = '/isBanned';
  static const String emailVerificationRoute = '/emailVerification';
  static const String homeRoute = '/home';
  static const String topicViewRoute = '/topicView';
  static const String topicFormRoute = '/topicForm';
  static const String postViewRoute = '/postViewRoute';
  static const String postFormRoute = '/postForm';
  static const String networkImageViewerRoute = '/networkImageViewer';
  static const String localImageViewerRoute = '/localImageViewer';

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
    navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }
  static void pop([String? argument]) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.pop(argument);
    });
  }
}