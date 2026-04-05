import 'package:dio/dio.dart';
import 'package:educational_complex_director_app/models/user.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserServices {
  final Dio dio;
  UserServices({required this.dio});
  Future<String> login(String email, String password) async {
    final response = await dio.post(
      '/token/generate',
      data: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(response.data['title']);
    }
    return response.data['accessToken'];
  }

  Future<User> getUser(String token) async {
    final response = await dio.get(
      '/current-user/claims',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['title']);
    }
    return User.fromJson(response.data);
  }
  
}

final userServiceProvider = Provider<UserServices>((ref) {
  final dio = Dio(
    BaseOptions(
      validateStatus: (status) {
        return status != null && status < 500;
      },
      baseUrl: '${SConfig.baseUrl}/identity',
      connectTimeout: const Duration(seconds: 10),
      headers: {
        // 'ngrok-skip-browser-warning':
        //     '1', // 👈 this line skips the warning page
        'Accept': 'application/json', // 👈 optional but recommended
      },
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  return UserServices(dio: dio);
});
