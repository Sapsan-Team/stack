import 'package:go_router/go_router.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/features/auth/presentation/auth_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: Routes.auth, builder: (context, state) => AuthScreen()),
  ],
);
