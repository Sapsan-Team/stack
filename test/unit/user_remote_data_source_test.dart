import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/auth/data/datasources/remote/user_remote_data_source_impl.dart';

class _RecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  final bodies = <Map<String, dynamic>>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (requestStream != null) {
      final bytes = await requestStream.expand((chunk) => chunk).toList();
      if (bytes.isNotEmpty) {
        bodies.add(jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>);
      }
    }

    final isMeRequest = options.path == '/api/auth/me';
    return ResponseBody.fromString(
      isMeRequest
          ? '{"id":"user-id","phoneNumber":"+77775556677"}'
          : '{"accessToken":"jwt-test-token","tokenType":"Bearer","expiresAt":"2026-10-01T12:00:00Z"}',
      isMeRequest ? 200 : (options.path.endsWith('/register') ? 201 : 200),
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late _RecordingAdapter adapter;
  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    adapter = _RecordingAdapter();
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:5121'))
      ..httpClientAdapter = adapter;
    dataSource = UserRemoteDataSourceImpl(dio);
  });

  tearDown(() {
    dio.close();
  });

  test('uses the ASP.NET login contract and bearer token for /me', () async {
    final token = await dataSource.fetchUserByPassword(
      '+77775556677',
      'password123',
    );
    final user = await dataSource.fetchCurrentUser(token.accessToken);

    expect(adapter.bodies.single, {
      'phoneNumber': '+77775556677',
      'password': 'password123',
    });
    expect(adapter.requests.last.path, '/api/auth/me');
    expect(
      adapter.requests.last.headers['Authorization'],
      'Bearer jwt-test-token',
    );
    expect(user.id, 'user-id');
    expect(user.phoneNumber, '+77775556677');
  });

  test('uses camelCase registration fields accepted by the API', () async {
    await dataSource.register(
      phoneNumber: '+77775556677',
      username: 'alice',
      displayName: 'Alice',
      password: 'password123',
    );

    expect(adapter.bodies.single, {
      'phoneNumber': '+77775556677',
      'username': 'alice',
      'displayName': 'Alice',
      'password': 'password123',
    });
  });
}
