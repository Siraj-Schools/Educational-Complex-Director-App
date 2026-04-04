import 'package:educational_complex_director_app/models/constants/teacher_designation.dart';
import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/models/helpers/paginated_response.dart';
import 'package:educational_complex_director_app/models/teacher/teacher.dart';
import 'package:educational_complex_director_app/models/teacher/teacher_details.dart';
import 'package:educational_complex_director_app/services/local_storage_services.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:educational_complex_director_app/services/teacher_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherRepository {
  final TeacherServices teacherServices;

  TeacherRepository({required this.teacherServices});

  Future<PaginatedResponse<Teacher>> getTeachers({
    String searchQuery = '',
    int page = 1,
    int pageSize = 6,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await teacherServices.getTeachers(
      token: token,
      searchQuery: searchQuery,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<TeacherDetails> getTeacher({
    required String id,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await teacherServices.getTeacher(
      token: token,
      id: id,
    );
  }

  Future<void> createTeacher({
    required Map<String, dynamic> body,
  }) async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception('Token not found');
      }
      await teacherServices.createTeacher(
        token: token,
        body: body,
      );
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> updateTeacher({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await teacherServices.updateTeacher(
      token: token,
      id: id,
      body: body,
    );
  }

  Future<void> changeSchoolOfTeacher({
    required String schoolId,
    required String teacherId,
    required TeacherDesignation designation,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await teacherServices.changeSchoolOfTeacher(
      token: token,
      schoolId: schoolId,
      teacherId: teacherId,
      designation: designation,
    );
  }

  Future<void> assignTeacherToSchool({
    required String schoolId,
    required String teacherId,
    required TeacherDesignation designation,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await teacherServices.assignTeacherToSchool(
      token: token,
      schoolId: schoolId,
      teacherId: teacherId,
      designation: designation,
    );
  }

  Future<NewCredentials> resetTeacherPassword({
    required String id,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await teacherServices.resetTeacherPassword(
      token: token,
      id: id,
    );
  }
}

final teacherRepositoryProvider = Provider<TeacherRepository>(
  (ref) => TeacherRepository(teacherServices: ref.read(teacherServiceProvider)),
);
