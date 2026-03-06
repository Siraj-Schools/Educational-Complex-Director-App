import 'package:educational_complex_director_app/models/enums/gender.dart';
import 'package:educational_complex_director_app/models/enums/marital_status.dart';
import 'package:educational_complex_director_app/models/school.dart';
import 'package:educational_complex_director_app/models/school_details.dart';
import 'package:educational_complex_director_app/models/school_manager.dart';
import 'package:educational_complex_director_app/view/pages/schoolspage/school_info_form.dart';
import 'package:educational_complex_director_app/view_model/schools_page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolDetailsPage extends ConsumerWidget {
  final String schoolId;
  final bool isEditing;

  const SchoolDetailsPage({
    super.key,
    required this.schoolId,
    required this.isEditing,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schoolsPageNavigationProvider);

    final dummyDetails = SchoolDetails(
      school: School(
        id: '11',
        name: "Future Academy",
        email: "info@future.com",
        phone: "12345678",
        address: "Oslo",
        stateId: "1",
        cityId: "1",
        schoolTypeId: "1",
        emisNumber: "EMIS001",
      ),
      manager: SchoolManager(
        managerEmail: "manager@future.com",
        userName: "admin",
        password: "123456",
        nationalId: "99887766",
        firstName: "John",
        middleName: "A",
        lastName: "Doe",
        managerMobileNumber: "123456789",
        gender: GenderEnum.male,
        dateOfBirth: DateTime(1990, 1, 1),
        maritalStatus: MaritalStatusEnum.single,
        managerCityId: "1",
        managerStateId: "1",
        managerCountryId: "1",
      ),
      moreInfo: "Top ranked private school",
    );
    //TODO add state managment when getting details
    // state.schoolId;
    return SchoolInfoForm(
      details: dummyDetails,
      isEditing: state.isEditing,
    );
  }
}
