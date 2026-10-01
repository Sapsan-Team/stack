import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';
import 'package:todo/features/auth/data/token_storage/auth_token_storage.dart';

final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return SecureAuthTokenStorage(
    secureStorage: const FlutterSecureStorage(),
    legacyPreferences: ref.watch(sharedPreferencesProvider),
  );
});
