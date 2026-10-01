import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/auth_session_events_provider.dart';
import 'package:todo/core/providers/dio_provider.dart';
import 'package:todo/features/auth/data/token_storage/auth_token_storage.dart';
import 'package:todo/features/auth/presentation/providers/auth_token_storage_provider.dart';
import 'package:todo/features/auth/domain/services/auth_session_events.dart';

class _MemoryTokenStorage implements AuthTokenStorage {
  String? token = 'active-token';
  int deleteCount = 0;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String token) async {
    this.token = token;
  }

  @override
  Future<void> delete() async {
    deleteCount++;
    token = null;
  }
}

class _UnauthorizedAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{"title":"Unauthorized","status":401}',
      401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'clears and broadcasts expiration for authenticated 401 responses',
    () async {
      final tokenStorage = _MemoryTokenStorage();
      final events = AuthSessionEventBus();
      final container = ProviderContainer(
        overrides: [
          authTokenStorageProvider.overrideWithValue(tokenStorage),
          authSessionEventsProvider.overrideWithValue(events),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(events.dispose);

      final adapter = _UnauthorizedAdapter();
      final dio = container.read(dioProvider)..httpClientAdapter = adapter;
      addTearDown(dio.close);
      var expirationEvents = 0;
      final subscription = events.expired.listen((_) => expirationEvents++);
      addTearDown(subscription.cancel);

      await expectLater(dio.get('/api/private'), throwsA(isA<DioException>()));

      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer active-token',
      );
      expect(tokenStorage.token, isNull);
      expect(tokenStorage.deleteCount, 1);
      expect(expirationEvents, 1);
    },
  );

  test('does not invalidate a session for failed login credentials', () async {
    final tokenStorage = _MemoryTokenStorage();
    final events = AuthSessionEventBus();
    final container = ProviderContainer(
      overrides: [
        authTokenStorageProvider.overrideWithValue(tokenStorage),
        authSessionEventsProvider.overrideWithValue(events),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(events.dispose);

    final adapter = _UnauthorizedAdapter();
    final dio = container.read(dioProvider)..httpClientAdapter = adapter;
    addTearDown(dio.close);
    var expirationEvents = 0;
    final subscription = events.expired.listen((_) => expirationEvents++);
    addTearDown(subscription.cancel);

    await expectLater(
      dio.post('/api/auth/login', data: {'phoneNumber': 'x', 'password': 'x'}),
      throwsA(isA<DioException>()),
    );

    expect(adapter.requests.single.headers['Authorization'], isNull);
    expect(tokenStorage.token, 'active-token');
    expect(expirationEvents, 0);
  });
}
