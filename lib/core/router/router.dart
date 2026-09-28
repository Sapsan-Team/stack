import 'package:go_router/go_router.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/features/auth/presentation/auth_screen.dart';
import 'package:todo/features/auth/presentation/register_screen.dart';
import 'package:todo/features/home/presentation/home_screen.dart';
import 'package:todo/features/home/presentation/pets_screen.dart';
import 'package:todo/features/home/presentation/profile_screen.dart';
import 'package:todo/features/home/presentation/tasks_screen.dart';
import 'package:todo/features/main/presentation/main_layout.dart';
import 'package:todo/widgets/navigation_bar.dart';

int _calculateSelectedIndex(String location) {
  if (location.startsWith(Routes.materials) ||
      location.startsWith(Routes.pets)) {
    return 1;
  }
  if (location.startsWith(Routes.vocabulary) ||
      location.startsWith(Routes.tasks)) {
    return 2;
  }
  if (location.startsWith(Routes.profile)) {
    return 3;
  }
  return 0;
}

final router = GoRouter(
  initialLocation: Routes.auth,
  routes: [
    GoRoute(
      path: Routes.auth,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const RegisterScreen(),
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
                  context.go(Routes.materials);
                case 2:
                  context.go(Routes.vocabulary);
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
          path: Routes.materials,
          builder: (context, state) => const PetsScreen(),
        ),
        GoRoute(
          path: Routes.pets,
          builder: (context, state) => const PetsScreen(),
        ),
        GoRoute(
          path: Routes.vocabulary,
          builder: (context, state) => const TasksScreen(),
        ),
        GoRoute(
          path: Routes.tasks,
          builder: (context, state) => const TasksScreen(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
