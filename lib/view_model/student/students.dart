import 'package:educational_complex_director_app/Repositories/student_repository.dart';

import 'package:educational_complex_director_app/models/student/student.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentsNotifier extends AsyncNotifier<List<Student>> {
  String searchQuery = '';
  int page = 1;
  bool hasNextPage = true;
  bool isLoadingMore = false;
  Exception? errorLoadingMore;
  Exception? errorAddingStudent;
  @override
  Future<List<Student>> build() async {
    return await getStudents();
  }

  Future<List<Student>> getStudents() async {
    // await Future.delayed(const Duration(seconds: 2));

    final response = await ref
        .read(studentRepositoryProvider)
        .getStudents(searchQuery: searchQuery, page: page);
    hasNextPage = response.hasNextPage;
    page = response.currentPage;

    return response.list;
  }

  Future<void> search(String query) async {
    searchQuery = query;
    page = 1;
    hasNextPage = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getStudents());
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
      final newStudents = await getStudents();

      state = AsyncValue.data([...state.value!, ...newStudents]);
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
    state = await AsyncValue.guard(() => getStudents());
  }

  Future<void> createStudent(Map<String, dynamic> body) async {
    errorAddingStudent = null;
    ref.notifyListeners();
    try {
      await ref.read(studentRepositoryProvider).createStudent(body: body);
    } catch (e) {
      if (e is Exception) {
        errorAddingStudent = e;
      } else {
        errorAddingStudent = Exception(e.toString());
      }
    }
  }
}

final studentsNotifierProvider =
    AsyncNotifierProvider<StudentsNotifier, List<Student>>(
      () => StudentsNotifier(),
    );
