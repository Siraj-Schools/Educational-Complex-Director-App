import 'package:dio/dio.dart';
import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/models/helpers/paginated_response.dart';
import 'package:educational_complex_director_app/models/student/parent.dart';
import 'package:educational_complex_director_app/models/student/student.dart';
import 'package:educational_complex_director_app/models/student/student_details.dart';
import 'package:educational_complex_director_app/services/dio.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentService {
  const StudentService({required this.dio});
  final Dio dio;
  Future<PaginatedResponse<Student>> getStudents({
    required String token,
    String searchQuery = '',
    int page = 1,
    int pageSize = 6,
  }) async {
    final response = await dio.get(
      '/students',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {
        if (searchQuery.isNotEmpty) 'SearchTerm': searchQuery,
        'Page': page,
        'PageSize': pageSize,
      },
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to get students');
    }
    return PaginatedResponse<Student>.fromJson(response.data);
  }

  Future<Parent> getParent({
    required String token,
    required String nationalId,
  }) async {
    final response = await dio.get(
      '/parents',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {'NationalId': nationalId},
    );
    if (response.statusCode != 200 || response.data['items'].isEmpty) {
      throw Exception('No parent with this national ID');
    }
    return Parent.fromParentApi(response.data["items"][0]);
  }

  Future<StudentDetails> getStudentDetails({
    required String token,
    required String studentId,
  }) async {
    final response = await dio.get(
      '/students/$studentId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to get student details');
    }
    return StudentDetails.fromJson(response.data);
  }

  Future<void> createStudent({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final response = await dio.post(
      '/admissions',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    );
    if (response.statusCode != 201) {
      LogService.e(response.data.toString());
      throw Exception('Failed to create student');
    }
  }

  Future<void> updateStudent({
    required String token,
    required String studentId,
    required Map<String, dynamic> body,
  }) async {
    final response = await dio.patch(
      '/students/$studentId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to update student');
    }
  }

  Future<NewCredentials> resetStudentParentPassword({
    required String token,
    required String studentId,
  }) async {
    final response = await dio.post(
      '/students/$studentId/parent/reset-password',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to reset student password');
    }
    return NewCredentials.fromJson(response.data, "parentEmail");
  }

  Future<void> transferToANewSchool({
    required String token,
    required String studentId,
    required String newSchoolId,
  }) async {
    final response = await dio.post(
      '/students/$studentId/transfer',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: {"newSchoolId": newSchoolId, "studentId": studentId},
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to transfer student to new school');
    }
  }
}

final studentServiceProvider = Provider<StudentService>(
  (ref) => StudentService(dio: ref.read(dioProvider)),
);
