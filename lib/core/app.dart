import "package:capital_commons/core/router.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/features/user/user_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class CapitalCommonsApp extends StatelessWidget {
  const CapitalCommonsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<UserCubit>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
        title: "Capital Exchange",
      ),
    );
  }
}
