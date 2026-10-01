import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';
import 'package:todo/core/router/router.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/features/auth/domain/entities/user.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/features/auth/presentation/providers/auth_state.dart';
import 'package:todo/features/home/presentation/home_screen.dart';
import 'package:todo/l10n/app_localizations.dart';

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(this.initialUser);

  final User? initialUser;

  @override
  AuthState build() => initialUser == null
      ? const AuthState.unauthenticated()
      : AuthState.authenticated(initialUser!);

  @override
  Future<void> restoreSession() async {}

  void setUser(User? user) => state = user == null
      ? const AuthState.unauthenticated()
      : AuthState.authenticated(user);
}

void main() {
  Future<({ProviderContainer container, GoRouter router})> pumpRouter(
    WidgetTester tester, {
    required User? user,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authNotifierProvider.overrideWith(() => _TestAuthNotifier(user)),
      ],
    );
    final router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ru')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (container: container, router: router);
  }

  testWidgets('redirects unauthenticated deep links to sign in', (
    tester,
  ) async {
    final app = await pumpRouter(tester, user: null);
    addTearDown(app.container.dispose);

    app.router.go(Routes.profile);
    await tester.pumpAndSettle();

    expect(app.router.routeInformationProvider.value.uri.path, Routes.auth);
  });

  testWidgets('redirects an authenticated user away from public auth routes', (
    tester,
  ) async {
    const user = User(id: 'user-id', phoneNumber: '+77775556677');
    final app = await pumpRouter(tester, user: user);
    addTearDown(app.container.dispose);

    expect(app.router.routeInformationProvider.value.uri.path, Routes.home);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('redirects to sign in when the authenticated user logs out', (
    tester,
  ) async {
    const user = User(id: 'user-id', phoneNumber: '+77775556677');
    final app = await pumpRouter(tester, user: user);
    addTearDown(app.container.dispose);

    (app.container.read(authNotifierProvider.notifier) as _TestAuthNotifier)
        .setUser(null);
    await tester.pumpAndSettle();

    expect(app.router.routeInformationProvider.value.uri.path, Routes.auth);
  });
}
