import 'package:dio/dio.dart';
import 'package:educational_complex_director_app/models/geography.dart';
import 'package:educational_complex_director_app/services/dio.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeographyServices {
  const GeographyServices({required this.dio});
  final Dio dio;

  Future<List<Geography>> getCountries({required String token}) async {
    final response = await dio.get(
      '/geographics/countries',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {'PageSize': 1000},
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load countries');
    }
    return (response.data['items'] as List<dynamic>)
        .map((e) => Geography.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Geography>> getStates({
    required String token,
    required String countryId,
  }) async {
    final response = await dio.get(
      '/geographics/countries/$countryId/states',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {'PageSize': 1000, 'CountryId': countryId},
    );

    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load states');
    }
    final items = (response.data['items'] as List<dynamic>)
        .map((e) => Geography.fromJson(e as Map<String, dynamic>))
        .toList();
    return items;
  }

  Future<List<Geography>> getCities({
    required String token,
    required String stateId,
  }) async {
    final response = await dio.get(
      '/geographics/states/$stateId/cities',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {
        'StateId': stateId,
        'PageSize': 1000,
      },
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load cities');
    }
    final items = (response.data['items'] as List<dynamic>)
        .map((e) => Geography.fromJson(e as Map<String, dynamic>))
        .toList();
    return items;
  }
}

final geographyServiceProvider = Provider<GeographyServices>(
  (ref) => GeographyServices(dio: ref.read(dioProvider)),
);
