import 'package:educational_complex_director_app/models/helpers/paginated_response.dart';
import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/models/school/school_details.dart';
import 'package:educational_complex_director_app/models/school/standard.dart';
import 'package:educational_complex_director_app/services/local_storage_services.dart';

import 'package:educational_complex_director_app/services/school_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolRepository {
  final SchoolServices schoolServices;
  SchoolRepository({required this.schoolServices});

  Future<PaginatedResponse<School>> getSchools({
    String searchQuery = '',
    int page = 1,
    int pageSize = 6,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await schoolServices.getSchools(
      token: token,
      searchQuery: searchQuery,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<SchoolDetails> getSchool({required String id}) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await schoolServices.getSchool(token: token, id: id);
  }

  Future<void> createSchool({
    required Map<String, dynamic> body,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await schoolServices.createSchool(token: token, body: body);
  }

  Future<void> updateSchool({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await schoolServices.updateSchool(token: token, id: id, body: body);
  }

  Future<void> removeManager({required String id}) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await schoolServices.removeManager(token: token, id: id);
  }

  Future<void> changeManager({
    required String schoolId,
    required String newManagerId,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await schoolServices.changeManager(
      token: token,
      schoolId: schoolId,
      newManagerId: newManagerId,
    );
  }

  Future<List<Standard>> getSchoolStandards({required String schoolId}) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await schoolServices.getSchoolStandards(
      token: token,
      schoolId: schoolId,
    );
  }
}

final schoolRepositoryProvider = Provider<SchoolRepository>(
  (ref) => SchoolRepository(schoolServices: ref.read(schoolServiceProvider)),
);
