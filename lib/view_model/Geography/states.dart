import 'package:educational_complex_director_app/Repositories/geography_repository.dart';
import 'package:educational_complex_director_app/models/geography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schoolStatesProvider = FutureProvider.family<List<Geography>, String>((
  ref,
  countryId,
) async {
  return await ref
      .read(geographyRepositoryProvider)
      .getStates(countryId: countryId);
});

final managerStatesProvider = FutureProvider.family<List<Geography>, String>((
  ref,
  countryId,
) async {
  return await ref
      .read(geographyRepositoryProvider)
      .getStates(countryId: countryId);
});
