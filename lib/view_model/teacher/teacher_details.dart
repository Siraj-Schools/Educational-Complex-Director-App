import 'package:educational_complex_director_app/Repositories/teacher_repostory.dart';
import 'package:educational_complex_director_app/models/constants/teacher_designation.dart';
import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/models/teacher/teacher_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teacherDetailsNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<TeacherDetailsNotifier, TeacherDetails, String>(
      (arg) => TeacherDetailsNotifier(arg),
    );

class TeacherDetailsNotifier extends AsyncNotifier<TeacherDetails> {
  final String id;
  TeacherDetailsNotifier(this.id);

  Exception? error;
  //Done
  @override
  Future<TeacherDetails> build() async {
    return await getTeacher();
  }

  //Done
  Future<TeacherDetails> getTeacher() async {
    // await Future.delayed(const Duration(seconds: 2));
    return await ref.read(teacherRepositoryProvider).getTeacher(id: id);
  }

  //Done
  Future<void> refresh() async {
    error = null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getTeacher());
  }

  Future<void> updateTeacher(Map<String, dynamic> body) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(teacherRepositoryProvider)
          .updateTeacher(id: id, body: body);
      refresh();
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
  }

  //Done
  Future<void> changeTeacherSchool(
    String schoolId,

    TeacherDesignation designation,
  ) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(teacherRepositoryProvider)
          .changeSchoolOfTeacher(
            schoolId: schoolId,
            teacherId: id,
            designation: designation,
          );
      refresh();
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
  }

  //Done
  Future<void> assignTeacherToSchool(
    String schoolId,

    TeacherDesignation designation,
  ) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(teacherRepositoryProvider)
          .assignTeacherToSchool(
            schoolId: schoolId,
            teacherId: id,
            designation: designation,
          );
      refresh();
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
  }

  //Done
  Future<NewCredentials?> resetTeacherPassword() async {
    error = null;
    ref.notifyListeners();
    try {
      return await ref
          .read(teacherRepositoryProvider)
          .resetTeacherPassword(id: id);
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
    return null;
  }
}
