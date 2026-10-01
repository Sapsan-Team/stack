import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/auth_session_events_provider.dart';
import 'package:todo/features/auth/presentation/providers/auth_token_storage_provider.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:5121',
);

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(authTokenStorageProvider);
  final sessionEvents = ref.watch(authSessionEventsProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: _apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isPublicAuthRequest =
            options.path == '/api/auth/login' ||
            options.path == '/api/auth/register';
        final token = isPublicAuthRequest ? null : await tokenStorage.read();
        if (token != null &&
            token.isNotEmpty &&
            options.headers['Authorization'] == null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        final isPublicAuthRequest =
            error.requestOptions.path == '/api/auth/login' ||
            error.requestOptions.path == '/api/auth/register';
        final authorizationHeader =
            error.requestOptions.headers['Authorization'];
        final hasBearerToken =
            authorizationHeader is String &&
            authorizationHeader.startsWith('Bearer ');
        if (!isPublicAuthRequest &&
            error.response?.statusCode == 401 &&
            hasBearerToken) {
          try {
            await tokenStorage.delete();
          } catch (exception, stackTrace) {
            debugPrint(
              'Could not clear the expired authentication token: '
              '$exception\n$stackTrace',
            );
          } finally {
            sessionEvents.notifyExpired();
          }
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});
