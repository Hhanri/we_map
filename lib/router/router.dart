import 'package:flutter/scheduler.dart';
import 'package:we_map/models/coment_model.dart';
import 'package:we_map/models/post_model.dart';
import 'package:we_map/models/topic_model.dart';
import 'package:we_map/pages/comments_page.dart';
import 'package:we_map/pages/post_view_page.dart';
import 'package:we_map/pages/default_page.dart';
import 'package:we_map/pages/image_viewer_page.dart';
import 'package:we_map/pages/topic_form_page.dart';
import 'package:flutter/material.dart';
import 'package:we_map/pages/topic_view_page.dart';
import 'package:we_map/pages/post_form_page.dart';
import 'package:we_map/pages/write_comment_reply_page.dart';
import 'package:we_map/screens/loading/loading_screen.dart';

class AppRouter {
  Route onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case defaultRoute: return returnPage(const DefaultRouterPage());
      case topicViewRoute: return returnPage(TopicViewPage(topic: settings.arguments as TopicModel, isOwner: false,));
      case topicFormRoute: return returnPage(TopicFormPage(initialTopic: settings.arguments as TopicModel));
      case postViewRoute: return returnPage(PostViewPage(post: settings.arguments as PostModel));
      case postFormRoute: return returnPage(PostFormPage(parentTopic: settings.arguments as TopicModel));
      case commentsRoute: return returnPage(CommentPage(post: settings.arguments as PostModel));
      case writeCommentRoute: return returnPage(WriteCommentReplyPage(post: settings.arguments as PostModel));
      case writeReplyRoute: return returnPage(WriteCommentReplyPage(comment: settings.arguments as CommentModel));
      case networkImageViewerRoute: return returnPage(NetworkImageViewerPage(url: settings.arguments as String));
      case localImageViewerRoute: return returnPage(LocalImageViewerPage(path: settings.arguments as String));
      default: return returnPage(const DefaultRouterPage());
    }
  }

  static const String defaultRoute = '/';
  static const String topicViewRoute = '/topicView';
  static const String topicFormRoute = '/topicForm';
  static const String postViewRoute = '/postViewRoute';
  static const String postFormRoute = '/postForm';
  static const String commentsRoute = '/comments';
  static const String writeCommentRoute = '/writeComment';
  static const String writeReplyRoute = '/writeReplyt';
  static const String networkImageViewerRoute = '/networkImageViewer';
  static const String localImageViewerRoute = '/localImageViewer';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  PageRouteBuilder returnPage(Widget child) {
    return PageRouteBuilder(pageBuilder: (context, __, ___) => child , opaque: false);
    //return MaterialPageRoute(builder: (context) => child);
  }

  static void pushNamedAndReplaceAll(String route) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      LoadingScreen.instance().hide();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(route, (route) => route.isFirst);
    });
  }
  static void pushNamed(String route, {dynamic arguments}) {
    navigatorKey.currentState!.pushNamed(
      route,
      arguments: arguments,
    );
  }

  static void pop([String? argument]) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.pop(argument);
    });
  }
}