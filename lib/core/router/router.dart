import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/features/auth/presentation/auth_screen.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/features/auth/presentation/register_screen.dart';
import 'package:todo/features/auth/presentation/session_error_screen.dart';
import 'package:todo/features/auth/presentation/providers/auth_state.dart';
import 'package:todo/features/home/presentation/home_screen.dart';
import 'package:todo/features/home/presentation/calls_screen.dart';
import 'package:todo/features/home/presentation/music_screen.dart';
import 'package:todo/features/home/presentation/profile_screen.dart';
import 'package:todo/features/main/presentation/main_layout.dart';
import 'package:todo/widgets/navigation_bar.dart';

int _calculateSelectedIndex(String location) {
  if (location.startsWith(Routes.calls)) {
    return 1;
  }
  if (location.startsWith(Routes.music)) {
    return 2;
  }
  if (location.startsWith(Routes.profile)) {
    return 3;
  }
  return 0;
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.listen(authNotifierProvider, (_, _) => refresh.refresh());

  final router = GoRouter(
    initialLocation: Routes.auth,
    refreshListenable: refresh,
    redirect: (context, state) async {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.restoreSession();

      final authState = ref.read(authNotifierProvider);
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isPublicRoute =
          state.matchedLocation == Routes.auth ||
          state.matchedLocation == Routes.register ||
          state.matchedLocation == Routes.sessionError;

      if (authState.status == AuthStatus.restorationFailed) {
        return state.matchedLocation == Routes.sessionError
            ? null
            : Routes.sessionError;
      }

      if (!isAuthenticated && !isPublicRoute) {
        return Routes.auth;
      }
      if (isAuthenticated && isPublicRoute) {
        return Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.sessionError,
        builder: (context, state) => const SessionErrorScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(
            bnb: BottomNavBar(
              currentIndex: _calculateSelectedIndex(state.uri.path),
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go(Routes.home);
                  case 1:
                    context.go(Routes.calls);
                  case 2:
                    context.go(Routes.music);
                  case 3:
                    context.go(Routes.profile);
                }
              },
            ),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: Routes.calls,
            builder: (context, state) => const CallsScreen(),
          ),
          GoRoute(
            path: Routes.music,
            builder: (context, state) => const MusicScreen(),
          ),
          GoRoute(
            path: Routes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});

class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}
