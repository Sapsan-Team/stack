import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/features/auth/domain/entities/user.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/features/auth/presentation/providers/auth_state.dart';
import 'package:todo/features/home/presentation/home_screen.dart';
import 'package:todo/features/home/presentation/profile_screen.dart';
import 'package:todo/features/main/presentation/main_layout.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/empty_state.dart';
import 'package:todo/widgets/navigation_bar.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'auth_token': 'dummy_token'});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('MainLayout renders HomeScreen, EmptyState and BottomNavBar', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ru')],
          home: MainLayout(
            bnb: BottomNavBar(currentIndex: 0, onTap: (_) {}),
            child: const HomeScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MainLayout), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);

    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.call_outlined), findsOneWidget);
    expect(find.byIcon(Icons.music_note_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
  });

  testWidgets('HomeScreen does not repeat profile details', (tester) async {
    const testUser = User(
      id: '123',
      phoneNumber: '+77011234567',
      username: 'alice',
      displayName: 'Alice Smith',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authNotifierProvider.overrideWith(() => _MockAuthNotifier(testUser)),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ru')],
          home: MainLayout(
            bnb: BottomNavBar(currentIndex: 0, onTap: (_) {}),
            child: const HomeScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Alice Smith'), findsNothing);
    expect(find.text('@alice'), findsNothing);
    expect(find.text('+77011234567'), findsNothing);
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(BottomNavBar), findsOneWidget);
  });

  testWidgets('ProfileScreen prefers username to phone number', (tester) async {
    const testUser = User(
      id: '123',
      phoneNumber: '+77011234567',
      username: 'alice',
      displayName: 'Alice Smith',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authNotifierProvider.overrideWith(() => _MockAuthNotifier(testUser)),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ru')],
          home: const ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('alice'), findsOneWidget);
    expect(find.text('Alice Smith'), findsOneWidget);
    expect(find.text('+77011234567'), findsOneWidget);
  });

  test('Routes contains all shell tab paths', () {
    expect(Routes.home, '/home');
    expect(Routes.calls, '/calls');
    expect(Routes.music, '/music');
    expect(Routes.profile, '/profile');
  });
}

class _MockAuthNotifier extends AuthNotifier {
  final User? initial;
  _MockAuthNotifier(this.initial);

  @override
  AuthState build() => initial == null
      ? const AuthState.unauthenticated()
      : AuthState.authenticated(initial!);
}
