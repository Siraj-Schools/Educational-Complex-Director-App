import 'package:educational_complex_director_app/models/helpers/paginated_response.dart';
import 'package:educational_complex_director_app/models/school/school_manager.dart';
import 'package:educational_complex_director_app/services/local_storage_services.dart';
import 'package:educational_complex_director_app/services/school_manger_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolManagerRepository {
  final SchoolMangerServices schoolMangerServices;
  SchoolManagerRepository({required this.schoolMangerServices});
  Future<PaginatedResponse<SchoolManager>> getManagers({
    String searchQuery = '',
    int page = 1,
    int pageSize = 6,
    bool? hasSchool,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await schoolMangerServices.getManagers(
      token: token,
      searchQuery: searchQuery,
      page: page,
      pageSize: pageSize,
      hasSchool: hasSchool,
    );
  }

  Future<SchoolManager> getManager({
    required String managerId,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await schoolMangerServices.getManager(
      token: token,
      managerId: managerId,
    );
  }

  Future<void> createManager({
    required Map<String, dynamic> body,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await schoolMangerServices.createManager(
      token: token,
      body: body,
    );
  }

  Future<void> updateManager({
    required String managerId,
    required Map<String, dynamic> body,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    await schoolMangerServices.updateManager(
      token: token,
      managerId: managerId,
      body: body,
    );
  }
}

final schoolManagerRepositoryProvider = Provider<SchoolManagerRepository>(
  (ref) => SchoolManagerRepository(
    schoolMangerServices: ref.read(schoolMangerServiceProvider),
  ),
);
