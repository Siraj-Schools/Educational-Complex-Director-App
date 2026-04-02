import 'package:dio/dio.dart';
import 'package:educational_complex_director_app/models/constants/teacher_designation.dart';
import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/models/helpers/paginated_response.dart';
import 'package:educational_complex_director_app/models/teacher/teacher.dart';
import 'package:educational_complex_director_app/models/teacher/teacher_details.dart';
import 'package:educational_complex_director_app/services/dio.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherServices {
  const TeacherServices({required this.dio});
  final Dio dio;

  Future<PaginatedResponse<Teacher>> getTeachers({
    required String token,
    String searchQuery = '',
    int page = 1,
    int pageSize = 6,
  }) async {
    final response = await dio.get(
      '/teachers',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {
        if (searchQuery.isNotEmpty) 'SearchTerm': searchQuery,
        'page': page,
        'pageSize': pageSize,
      },
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load schools');
    }
    return PaginatedResponse.fromJson(response.data);
  }

  Future<TeacherDetails> getTeacher({
    required String token,
    required String id,
  }) async {
    final response = await dio.get(
      '/teachers/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load school');
    }
    return TeacherDetails.fromJson(response.data);
  }

  Future<void> createTeacher({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final response = await dio.post(
      '/teachers',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    );
    if (response.statusCode != 200 && response.statusCode != 500) {
      LogService.e(response.data['title']);
      LogService.e(response.data['errors'].toString());
      throw Exception('Failed to create school');
    }
  }

  Future<void> updateTeacher({
    required String token,
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final response = await dio.patch(
      '/teachers/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to update school');
    }
  }

  Future<void> removeTeacherFromSchool({
    required String token,
    required String schoolId,
    required String teacherId,
  }) async {
    final response = await dio.delete(
      '/schools/$schoolId/teachers/$teacherId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to remove manager');
    }
  }

  Future<void> changeSchoolOfTeacher({
    required String token,
    required String schoolId,
    required String teacherId,
    required TeacherDesignation designation,
  }) async {
    final response = await dio.put(
      '/schools/$schoolId/teachers/$teacherId/change-school',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        'designation': designation.index,
      },
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to change manager');
    }
  }

  Future<void> assignTeacherToSchool({
    required String token,
    required String schoolId,
    required String teacherId,
    required TeacherDesignation designation,
  }) async {
    final response = await dio.post(
      '/schools/$schoolId/teachers/$teacherId/assign',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        'designation': designation.index,
      },
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to change manager');
    }
  }

  Future<NewCredentials> resetTeacherPassword({
    required String token,
    required String id,
  }) async {
    final response = await dio.post(
      '/teachers/$id/reset-password',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to reset password');
    }
    return NewCredentials.fromJson(response.data, 'teacherEmail');
  }
}

final teacherServiceProvider = Provider<TeacherServices>(
  (ref) => TeacherServices(dio: ref.read(dioProvider)),
);
