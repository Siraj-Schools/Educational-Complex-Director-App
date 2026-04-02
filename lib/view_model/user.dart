import 'package:educational_complex_director_app/Repositories/user_repository.dart';
import 'package:educational_complex_director_app/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserViewModel extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    return await loadUser();
  }

  Future<User> loadUser() async {
    return await ref.read(userRepositoryProvider).getUser();
  }
}

final userViewModelProvider = AsyncNotifierProvider<UserViewModel, User>(
  () => UserViewModel(),
  retry: (retryCount, error) => null,
);
