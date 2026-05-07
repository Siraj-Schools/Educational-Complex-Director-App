import 'package:educational_complex_director_app/Repositories/school_repository.dart';
import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/view_model/schoolmanager/school_managers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolsNotifier extends AsyncNotifier<List<School>> {
  String searchQuery = '';
  int page = 1;
  bool hasNextPage = true;
  bool isLoadingMore = false;
  Exception? errorLoadingMore;
  Exception? errorAddingSchool;
  @override
  Future<List<School>> build() async {
    return await getSchools();
  }

  Future<List<School>> getSchools() async {
    // await Future.delayed(const Duration(seconds: 2));

    final response = await ref
        .read(schoolRepositoryProvider)
        .getSchools(searchQuery: searchQuery, page: page);
    hasNextPage = response.hasNextPage;
    page = response.currentPage;

    return response.list;
  }

  Future<void> search(String query) async {
    searchQuery = query;
    page = 1;
    hasNextPage = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getSchools());
  }

  Future<void> loadMore() async {
    if (!hasNextPage) return;
    if (isLoadingMore) return;
    errorLoadingMore = null;
    page++;
    isLoadingMore = true;

    // Notify the UI to show the loading indicator
    ref.notifyListeners();

    try {
      final newSchools = await getSchools();

      state = AsyncValue.data([...state.value!, ...newSchools]);
    } catch (e, _) {
      if (e is Exception) {
        errorLoadingMore = e;
      } else {
        errorLoadingMore = Exception(e.toString());
      }
    }
    isLoadingMore = false;
    if (errorLoadingMore != null) {
      page--;
      hasNextPage = true;
    }
    ref.notifyListeners();
    // Force Riverpod to update UI for side effects (error, loading)
  }

  Future<void> refresh() async {
    page = 1;
    hasNextPage = true;
    searchQuery = '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getSchools());
  }

  Future<void> createSchool(Map<String, dynamic> body) async {
    errorAddingSchool = null;
    ref.notifyListeners();
    try {
      await ref.read(schoolRepositoryProvider).createSchool(body: body);
    } catch (e) {
      if (e is Exception) {
        errorAddingSchool = e;
      } else {
        errorAddingSchool = Exception(e.toString());
      }
    }
  }
}

final schoolsNotifierProvider =
    AsyncNotifierProvider.family<SchoolsNotifier, List<School>, bool>(
      (isSchoolPage) => SchoolsNotifier(),
    );
