import 'package:educational_complex_director_app/Repositories/school_manager_repository.dart';
import 'package:educational_complex_director_app/models/school/school_manager.dart';
import 'package:educational_complex_director_app/view_model/schoolmanager/school_managers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schoolManagerDetailsNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<SchoolManagerDetailsNotifier, SchoolManager, String>(
      (id) => SchoolManagerDetailsNotifier(id),
    );

class SchoolManagerDetailsNotifier extends AsyncNotifier<SchoolManager> {
  final String id;
  SchoolManagerDetailsNotifier(this.id);

  Exception? error;

  @override
  Future<SchoolManager> build() async {
    return await getSchool();
  }

  Future<SchoolManager> getSchool() async {
    // await Future.delayed(const Duration(seconds: 2));
    return await ref
        .read(schoolManagerRepositoryProvider)
        .getManager(managerId: id);
  }

  Future<void> refresh() async {
    error = null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getSchool());
  }

  Future<void> updateManager(String id, Map<String, dynamic> body) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(schoolManagerRepositoryProvider)
          .updateManager(managerId: id, body: body);
      await refresh();
      await ref.read(schoolManagersNotifierProvider(true).notifier).refresh();
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
  }
}
