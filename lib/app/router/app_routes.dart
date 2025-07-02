import '../../core.dart';
import '../../features/main_page/view/add_user_view.dart';
import '../../features/main_page/view/home_view.dart';
import '../../features/main_page/view/user_details_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteName.homeView,
    navigatorKey: Global.navigatorKey,
    debugLogDiagnostics: true,
    restorationScopeId: "Users Book",
    requestFocus: false,

    routes: [
      GoRoute(path: RouteName.homeView, pageBuilder: (context, state) => appCustomTransitionPage(state: state, child: HomeView())),
      GoRoute(path: RouteName.addUser, pageBuilder: (context, state) => appCustomTransitionPage(state: state, child: AddUserView())),
      GoRoute(
        path: RouteName.userDetails,
        pageBuilder: (context, state) {
          final int? userId = state.extra as int?;
          return appCustomTransitionPage(state: state, child: UserDetailsView(userId: userId ?? 0));
        },
      ),
    ],
    errorBuilder: (context, state) => const AppPageNotFound(),
  );

  static CustomTransitionPage<dynamic> appCustomTransitionPage({
    required GoRouterState state,
    required Widget child,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget) transitionsBuilder = transition,
  }) {
    return CustomTransitionPage(key: state.pageKey, child: child, transitionsBuilder: transitionsBuilder);
  }

  static Widget transition(context, animation, secondaryAnimation, child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
