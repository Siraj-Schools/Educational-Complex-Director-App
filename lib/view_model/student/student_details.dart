import 'package:educational_complex_director_app/Repositories/student_repository.dart';
import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/models/student/student_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentDetailsNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<StudentDetailsNotifier, StudentDetails, String>(
      (arg) => StudentDetailsNotifier(arg),
    );

class StudentDetailsNotifier extends AsyncNotifier<StudentDetails> {
  final String id;
  StudentDetailsNotifier(this.id);

  Exception? error;
  //Done
  @override
  Future<StudentDetails> build() async {
    return await getStudent();
  }

  //Done
  Future<StudentDetails> getStudent() async {
    // await Future.delayed(const Duration(seconds: 2));
    return await ref
        .read(studentRepositoryProvider)
        .getStudentDetails(studentId: id);
  }

  //Done
  Future<void> refresh() async {
    error = null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => getStudent());
  }

  Future<void> updateStudent(Map<String, dynamic> body) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(studentRepositoryProvider)
          .updateStudent(studentId: id, body: body);
      await refresh();
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
  }

  //Done

  //Done
  Future<void> transferStudent({required String newSchoolId}) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(studentRepositoryProvider)
          .transferToANewSchool(
            studentId: id,
            newSchoolId: newSchoolId,
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
  Future<NewCredentials?> resetStudentParentPassword() async {
    error = null;
    ref.notifyListeners();
    try {
      return await ref
          .read(studentRepositoryProvider)
          .resetStudentParentPassword(studentId: id);
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
