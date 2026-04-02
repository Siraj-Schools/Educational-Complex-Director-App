import 'package:educational_complex_director_app/Repositories/school_repository.dart';
import 'package:educational_complex_director_app/models/school/school_details.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:educational_complex_director_app/view_model/school/schools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schoolDetailsNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<SchoolDetailsNotifier, SchoolDetails, String>(
      (arg) => SchoolDetailsNotifier(arg),
    );

class SchoolDetailsNotifier extends AsyncNotifier<SchoolDetails> {
  final String id;
  SchoolDetailsNotifier(this.id);

  Exception? error;
  @override
  Future<SchoolDetails> build() async {
    return await getSchool();
  }

  Future<SchoolDetails> getSchool() async {
    // await Future.delayed(const Duration(seconds: 2));
    return await ref.read(schoolRepositoryProvider).getSchool(id: id);
  }

  Future<void> refresh() async {
    error = null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getSchool());
  }

  Future<void> updateSchool(String id, Map<String, dynamic> body) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref.read(schoolRepositoryProvider).updateSchool(id: id, body: body);
      await refresh();
      await ref.read(schoolsNotifierProvider(true).notifier).refresh();
    } catch (e) {
      error = e as Exception;
    }
  }

  Future<void> removeManager(String id) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref.read(schoolRepositoryProvider).removeManager(id: id);
      await refresh();
    } catch (e) {
      error = e as Exception;
      LogService.e(e.toString());
    }
  }

  Future<void> changeManager(String newManagerId) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(schoolRepositoryProvider)
          .changeManager(
            schoolId: id,
            newManagerId: newManagerId,
          );
      await refresh();
    } catch (e) {
      error = e as Exception;
      LogService.e(e.toString());
    }
  }
}
