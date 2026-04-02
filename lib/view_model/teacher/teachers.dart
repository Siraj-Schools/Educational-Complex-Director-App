import 'package:educational_complex_director_app/Repositories/teacher_repostory.dart';
import 'package:educational_complex_director_app/models/teacher/teacher.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeachersNotifier extends AsyncNotifier<List<Teacher>> {
  String searchQuery = '';
  int page = 1;
  bool hasNextPage = true;
  bool isLoadingMore = false;
  Exception? errorLoadingMore;
  Exception? errorAddingTeacher;
  @override
  Future<List<Teacher>> build() async {
    return await getTeachers();
  }

  Future<List<Teacher>> getTeachers() async {
    // await Future.delayed(const Duration(seconds: 2));

    final response = await ref
        .read(teacherRepositoryProvider)
        .getTeachers(searchQuery: searchQuery, page: page);
    hasNextPage = response.hasNextPage;
    page = response.currentPage;

    return response.list;
  }

  Future<void> search(String query) async {
    searchQuery = query;
    page = 1;
    hasNextPage = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getTeachers());
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
      final newTeachers = await getTeachers();

      state = AsyncValue.data([...state.value!, ...newTeachers]);
    } catch (e, _) {
      errorLoadingMore = e as Exception;
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
    state = await AsyncValue.guard(() => getTeachers());
  }

  Future<void> createTeacher(Map<String, dynamic> body) async {
    errorAddingTeacher = null;
    ref.notifyListeners();
    try {
      await ref.read(teacherRepositoryProvider).createTeacher(body: body);
      await refresh();
    } catch (e) {
      LogService.e(e.toString());
      errorAddingTeacher = e as Exception;
    }
  }
}

final teachersNotifierProvider =
    AsyncNotifierProvider<TeachersNotifier, List<Teacher>>(
      () => TeachersNotifier(),
    );
