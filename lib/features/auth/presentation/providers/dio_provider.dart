import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return DioClient.create(
    accessToken: authState.accessToken,
    tokenRefresher: () async {
      final notifier = ref.read(authNotifierProvider.notifier);
      await notifier.refreshToken();
      return ref.read(authNotifierProvider).accessToken;
    },
  );
});
