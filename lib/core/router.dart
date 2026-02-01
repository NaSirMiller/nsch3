import "package:flutter/cupertino.dart";
import "package:go_router/go_router.dart";

import "package:capital_commons/features/landing/views/landing_page.dart";
import "package:capital_commons/features/signup/views/signup_page.dart";
import "package:capital_commons/features/login/views/login_page.dart";

import "package:capital_commons/features/investor_signup/views/investor_signup_page.dart";
import "package:capital_commons/features/business_signup/views/business_signup_page.dart";

import "package:capital_commons/features/investor_dashboard/views/investor_dashboard_page.dart";
import "package:capital_commons/features/business_dashboard/views/business_dashboard_page.dart";

import "package:capital_commons/features/market/views/market_page.dart";
import "package:capital_commons/features/market/views/business_detail_page.dart";

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    /// Landing
    GoRoute(
      path: "/",
      builder: (_, _) => const LandingPage(),
    ),

    /// Signup
    GoRoute(
      path: "/signup",
      builder: (_, _) => const SignupPage(),
      routes: [
        GoRoute(
          path: "investor",
          builder: (_, _) => const InvestorSignupPage(),
        ),
        GoRoute(
          path: "business",
          builder: (_, _) => const BusinessSignupPage(),
        ),
      ],
    ),

    /// Login
    GoRoute(
      path: "/login",
      builder: (_, _) => const LoginPage(),
    ),

    /// Dashboards
    GoRoute(
      path: "/business/dashboard",
      builder: (_, _) => const BusinessDashboardPage(),
    ),
    GoRoute(
      path: "/investor/dashboard",
      builder: (_, _) => const InvestorDashboardPage(),
    ),

    /// Market
    GoRoute(
      path: "/market",
      builder: (_, _) => const MarketPage(),
    ),
    GoRoute(
      path: "/market/:id",
      builder: (_, state) => BusinessDetailPage(
        businessId: state.pathParameters["id"]!,
      ),
    ),
  ],
);
