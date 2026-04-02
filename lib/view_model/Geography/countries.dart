import 'package:educational_complex_director_app/Repositories/geography_repository.dart';
import 'package:educational_complex_director_app/models/geography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final countriesProvider = FutureProvider<List<Geography>>((ref) async {
  return await ref.read(geographyRepositoryProvider).getCountries();
});
