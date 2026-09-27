// core/network/dio_provider.dart
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // - Android Emulator: 'http://10.0.2.2:8080'
      // - iOS Simulator / Desktop: 'http://localhost:8080'
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  return dio;
});
