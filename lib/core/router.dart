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
import "package:capital_commons/features/market/views/secondary_market_page.dart";
import "package:capital_commons/features/market/views/secondary_listing_detail_page.dart";
import "package:capital_commons/features/user/user_cubit.dart";
import "package:capital_commons/core/service_locator.dart";
import "dart:async";

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  refreshListenable: GoRouterRefreshStream(getIt<UserCubit>().stream),
  redirect: (context, state) {
    final userCubit = getIt<UserCubit>();
    final currentUser = userCubit.state.currentUser;
    final isOnLanding = state.matchedLocation == '/';

    // If user is logged in and on landing page, redirect to market
    if (currentUser != null && isOnLanding) {
      return '/market';
    }

    // No redirect needed
    return null;
  },
  routes: [
    /// Landing
    GoRoute(path: "/", builder: (_, _) => const LandingPage()),

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
    GoRoute(path: "/login", builder: (_, _) => const LoginPage()),

    /// Dashboards
    GoRoute(
      path: "/business/dashboard",
      builder: (_, _) => const BusinessDashboardPage(),
    ),
    GoRoute(
      path: "/investor/dashboard",
      builder: (_, _) => const InvestorDashboardPage(),
    ),

    /// Market - Order matters! Specific routes before parameterized routes
    GoRoute(path: "/market", builder: (_, _) => const MarketPage()),
    GoRoute(
      path: "/market/secondary",
      builder: (_, _) => const SecondaryMarketPage(),
    ),
    GoRoute(
      path: "/market/secondary/:listingId",
      builder: (_, state) => SecondaryListingDetailPage(
        listingId: state.pathParameters["listingId"]!,
      ),
    ),
    GoRoute(
      path: "/market/:id",
      builder: (_, state) =>
          BusinessDetailPage(businessId: state.pathParameters["id"]!),
    ),
  ],
);

// Helper class to make GoRouter refresh when UserCubit state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
