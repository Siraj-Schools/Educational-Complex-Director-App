import 'package:educational_complex_director_app/models/user.dart';
import 'package:educational_complex_director_app/services/local_storage_services.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:educational_complex_director_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final UserServices userServices;
  UserRepository({required this.userServices});
  Future<void> login(String email, String password) async {
    try {
      final token = await userServices.login(email, password);
      if (await LocalStorageService.setToken(token)) {
        return;
      }

      throw Exception('Failed to save token');
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      if (await LocalStorageService.clearToken()) {
        return;
      }
      LogService.e('Failed to logout');
      throw Exception('Failed to logout');
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<User> getUser() async {
    try {
      final String? token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception('Token not found');
      }
      final user = await userServices.getUser(token);

      if (!user.isDirector && !user.isEducationalComplexPrincipel) {
        throw Exception('User is not authorized to access this system');
      }
      LogService.d("User info: ${user.role} ______");
      LogService.d("Token info: $token ______");
      return user;
    } catch (e) {
      await logout();
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> setAppLanguage(String language) async {
    try {
      if (await LocalStorageService.setLang(language)) {
        return;
      }
      LogService.e('Failed to set language');
      throw Exception('Failed to set language');
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  String getAppLanguage() {
    try {
      final String? language = LocalStorageService.getLang;
      if (language == null) {
        return 'ar';
      }
      return language;
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userServices = ref.watch(userServiceProvider);
  return UserRepository(userServices: userServices);
});
