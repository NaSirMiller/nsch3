import "package:capital_commons/core/router.dart";
import "package:flutter/material.dart";

class CapitalCommonsApp extends StatelessWidget {
  const CapitalCommonsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: goRouter);
  }
}
