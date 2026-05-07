import 'package:educational_complex_director_app/Repositories/school_manager_repository.dart';
import 'package:educational_complex_director_app/models/school/school_manager.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolManagersNotifier extends AsyncNotifier<List<SchoolManager>> {
  String searchQuery = '';
  int page = 1;
  bool hasNextPage = true;
  bool isLoadingMore = false;
  Exception? errorLoadingMore;
  Exception? errorAddingManager;
  final bool isManagersPage;
  SchoolManagersNotifier({required this.isManagersPage});
  @override
  Future<List<SchoolManager>> build() async {
    return await getManagers();
  }

  Future<List<SchoolManager>> getManagers() async {
    // await Future.delayed(const Duration(seconds: 2));

    final response = await ref
        .read(schoolManagerRepositoryProvider)
        .getManagers(
          searchQuery: searchQuery,
          page: page,
          hasSchool: isManagersPage ? null : false,
        );
    hasNextPage = response.hasNextPage;
    page = response.currentPage;

    return response.list;
  }

  Future<void> search(String query) async {
    searchQuery = query;
    page = 1;
    hasNextPage = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getManagers());
  }

  Future<void> loadMore() async {
    if (!hasNextPage) return;
    if (isLoadingMore) return;
    if (!ref.mounted) return;
    errorLoadingMore = null;
    page++;
    isLoadingMore = true;

    // Notify the UI to show the loading indicator

    ref.notifyListeners();

    try {
      final newManagers = await getManagers();

      state = AsyncValue.data([...state.value!, ...newManagers]);
    } catch (e, _) {
      errorLoadingMore = e as Exception;
    }
    isLoadingMore = false;
    if (errorLoadingMore != null) {
      page--;
      hasNextPage = true;
    }
    if (!ref.mounted) return;
    ref.notifyListeners();
    // Force Riverpod to update UI for side effects (error, loading)
  }

  Future<void> refresh() async {
    page = 1;
    hasNextPage = true;
    searchQuery = '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getManagers());
  }

  Future<void> createManager(Map<String, dynamic> body) async {
    errorAddingManager = null;
    ref.notifyListeners();
    try {
      await ref.read(schoolManagerRepositoryProvider).createManager(body: body);
    } catch (e) {
      if (e is Exception) {
        errorAddingManager = e;
      } else {
        errorAddingManager = Exception(e.toString());
      }
    }
  }
}

final schoolManagersNotifierProvider =
    AsyncNotifierProvider.family<
      SchoolManagersNotifier,
      List<SchoolManager>,
      bool
    >(
      (isManagersPage) =>
          SchoolManagersNotifier(isManagersPage: isManagersPage),
    );
