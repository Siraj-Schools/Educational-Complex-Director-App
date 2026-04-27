import 'package:educational_complex_director_app/Repositories/user_repository.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initial state is nothing
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).login(email, password);
      await ref.read(userRepositoryProvider).getUser();
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).logout();
      ref.invalidate(activePageProvider);
      ref.invalidate(schoolsBreadcrumbProvider);
      ref.invalidate(managersBreadcrumbProvider);
      ref.invalidate(teachersBreadcrumbProvider);
      ref.invalidate(studentsBreadcrumbProvider);
    });
  }
}

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, void>(
  () => AuthViewModel(),
  retry: (retryCount, error) => null,
);
