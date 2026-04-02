import 'package:educational_complex_director_app/Repositories/geography_repository.dart';
import 'package:educational_complex_director_app/models/geography.dart';
import 'package:educational_complex_director_app/view_model/Geography/states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schoolCitiesProvider = FutureProvider.family<List<Geography>, String>((
  ref,
  stateId,
) async {
  ref.watch(schoolStatesProvider(stateId));
  return await ref
      .read(geographyRepositoryProvider)
      .getCities(stateId: stateId);
});

final managerCitiesProvider = FutureProvider.family<List<Geography>, String>((
  ref,
  stateId,
) async {
  ref.watch(managerStatesProvider(stateId));

  return await ref
      .read(geographyRepositoryProvider)
      .getCities(stateId: stateId);
});
