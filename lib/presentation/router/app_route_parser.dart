import 'package:flutter/material.dart';

class AppRouteParser extends RouteInformationParser<Object> {
  const AppRouteParser();

  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) async {
    return Object();
  }

  @override
  RouteInformation restoreRouteInformation(Object configuration) {
    return const RouteInformation(location: '/');
  }
}
