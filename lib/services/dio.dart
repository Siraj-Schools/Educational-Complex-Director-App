import 'package:dio/dio.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      // baseUrl: 'https://unlugubriously-balsamy-ward.ngrok-free.dev/api',
      baseUrl: '${SConfig.baseUrl}/api/v1',
      connectTimeout: const Duration(seconds: 10),
      headers: {
        // 'ngrok-skip-browser-warning':
        //     '1', // 👈 this line skips the warning page
        'Accept': 'application/json', // 👈 optional but recommended
      },
      receiveTimeout: const Duration(seconds: 30),
    ),
  ),
);
