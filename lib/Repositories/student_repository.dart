import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/models/helpers/paginated_response.dart';
import 'package:educational_complex_director_app/models/student/parent.dart';
import 'package:educational_complex_director_app/models/student/student.dart';
import 'package:educational_complex_director_app/models/student/student_details.dart';
import 'package:educational_complex_director_app/services/local_storage_services.dart';
import 'package:educational_complex_director_app/services/student_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentRepository {
  const StudentRepository({required this.studentService});
  final StudentService studentService;

  Future<PaginatedResponse<Student>> getStudents({
    String searchQuery = '',
    int page = 1,
    int pageSize = 6,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await studentService.getStudents(
      token: token,
      searchQuery: searchQuery,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<Parent> getParent({required String nationalId}) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await studentService.getParent(
      token: token,
      nationalId: nationalId,
    );
  }

  Future<StudentDetails> getStudentDetails({
    required String studentId,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await studentService.getStudentDetails(
      token: token,
      studentId: studentId,
    );
  }

  Future<void> createStudent({
    required Map<String, dynamic> body,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await studentService.createStudent(
      token: token,
      body: body,
    );
  }

  Future<void> updateStudent({
    required String studentId,
    required Map<String, dynamic> body,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await studentService.updateStudent(
      token: token,
      studentId: studentId,
      body: body,
    );
  }

  Future<NewCredentials> resetStudentParentPassword({
    required String studentId,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await studentService.resetStudentParentPassword(
      token: token,
      studentId: studentId,
    );
  }

  Future<void> transferToANewSchool({
    required String studentId,
    required String newSchoolId,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await studentService.transferToANewSchool(
      token: token,
      studentId: studentId,
      newSchoolId: newSchoolId,
    );
  }
}

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => StudentRepository(studentService: ref.read(studentServiceProvider)),
);
