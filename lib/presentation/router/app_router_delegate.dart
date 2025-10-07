import 'package:flutter/material.dart';
import '../pages/prompt_page.dart';
import '../pages/result_page.dart';
import 'app_state.dart';

class AppRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AppState appState;

  AppRouterDelegate(this.appState) {
    appState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appState.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const MaterialPage(child: PromptPage()),
      if (appState.showResult) const MaterialPage(child: ResultPage()),
    ];

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        if (appState.showResult) {
          appState.goToPrompt();
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}
