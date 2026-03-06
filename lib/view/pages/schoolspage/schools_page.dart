// ignore_for_file: file_names

import 'package:educational_complex_director_app/view/pages/schoolspage/school_details_page.dart';
import 'package:educational_complex_director_app/view/pages/schoolspage/school_info_form.dart';
import 'package:educational_complex_director_app/view/pages/schoolspage/schools_list_page.dart';
import 'package:educational_complex_director_app/view_model/schools_page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolsPage extends ConsumerWidget {
  const SchoolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schoolsPageNavigationProvider);

    switch (state.view) {
      case SchoolsViewType.list:
        return const SchoolListPage();

      case SchoolsViewType.add:
        return const SchoolInfoForm();

      case SchoolsViewType.details:
        return SchoolDetailsPage(
          schoolId: state.schoolId!,
          isEditing: state.isEditing,
        );
    }
  }
}
