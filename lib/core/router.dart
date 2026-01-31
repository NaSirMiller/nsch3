import "package:flutter/cupertino.dart";
import "package:go_router/go_router.dart";

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [GoRoute(path: "/", builder: (_, _) => const Placeholder())],
);
