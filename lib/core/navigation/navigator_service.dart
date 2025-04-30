import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context =>
      navigatorKey.currentState?.overlay?.context;

  static Future<dynamic> push(Widget page) {
    return navigatorKey.currentState!.push(
      CupertinoPageRoute(builder: (_) => page),
    );
  }

  static Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushReplacement(Widget page) {
    return navigatorKey.currentState!.pushReplacement(
      CupertinoPageRoute(builder: (_) => page, fullscreenDialog: true),
    );
  }

  static Future<dynamic> pushReplacementNamed(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void pop() {
    return navigatorKey.currentState!.pop();
  }

  static void popUntil(String routeName) {
    return navigatorKey.currentState!.popUntil(
      (route) => route.settings.name == routeName,
    );
  }

  static void popWithResult<T>(T result) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  static Future<dynamic> pushAndRemoveUntil(Widget page) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showToast(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
