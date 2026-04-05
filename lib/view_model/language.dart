import 'dart:async';

import 'package:educational_complex_director_app/Repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageViewModel extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return ref.read(userRepositoryProvider).getAppLanguage();
  }

  Future<void> setLanguage(String language) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).setAppLanguage(language);
      return language;
    });
  }
}

final languageViewModelProvider =
    AsyncNotifierProvider<LanguageViewModel, String>(() => LanguageViewModel());
