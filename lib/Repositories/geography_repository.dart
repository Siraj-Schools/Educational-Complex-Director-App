import 'package:educational_complex_director_app/models/geography.dart';
import 'package:educational_complex_director_app/services/geography_services.dart';
import 'package:educational_complex_director_app/services/local_storage_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeographyRepository {
  const GeographyRepository({required this.services});
  final GeographyServices services;

  Future<List<Geography>> getCountries() async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await services.getCountries(token: token);
  }

  Future<List<Geography>> getStates({
    required String countryId,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await services.getStates(token: token, countryId: countryId);
  }

  Future<List<Geography>> getCities({
    required String stateId,
  }) async {
    final token = LocalStorageService.getToken;
    if (token == null) {
      throw Exception('Token not found');
    }
    return await services.getCities(token: token, stateId: stateId);
  }
}

final geographyRepositoryProvider = Provider<GeographyRepository>(
  (ref) => GeographyRepository(services: ref.read(geographyServiceProvider)),
);
