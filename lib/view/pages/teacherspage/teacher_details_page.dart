import 'package:educational_complex_director_app/models/teacher/teacher_details.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/pages/teacherspage/teacher_info_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherDetailsPage extends ConsumerWidget {
  const TeacherDetailsPage({super.key, required this.teacherId});

  final String teacherId;

  Widget _teacherHeader(BuildContext context, TeacherDetails t) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          gradient: const LinearGradient(
            colors: [
              SConfig.accentColor,
              SConfig.secondaryBackground,
            ],
          ),
        ),
        child: SConfig.isDesktop()
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${t.designation} • ${t.qualificationName}",
                          style: const TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 14),

                        Wrap(
                          spacing: 12,
                          children: [
                            _chip(Icons.badge, t.registrationNumber),
                            _chip(Icons.school, t.schoolName),
                            _chip(
                              Icons.calendar_month,
                              t.joiningDateUtc.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${t.designation} • ${t.qualificationName}",
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _chip(Icons.badge, t.registrationNumber),
                      _chip(Icons.school, t.schoolName),
                      _chip(
                        Icons.calendar_month,
                        t.joiningDateUtc,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SConfig.init(context);

    /// dummy
    final teacher = TeacherDetails(
      id: "a7d904f3-b9bf-4367-a3dd-0dfd5922bc22",
      userId: "69ca1e76-d4b7-4a0d-bee0-4660271efb12",
      userName: "teacher.stevvfrank",
      email: "teacherstevfrank@greenwood.edu",
      nationalId: "NAT-987654321",
      registrationNumber: "2026068538",
      firstName: "Ahmed",
      middleName: "Ali",
      lastName: "Hassan",
      fullName: "Ahmed Ali Hassan",
      mobileNumber: "+1-217-555-0202",
      gender: "Male",
      dateOfBirth: DateTime(1990, 3, 20),
      maritalStatus: "Married",
      joiningDateUtc: "2026-03-06",
      cityName: "Damascus",
      stateName: "Damascus",
      countryName: "Syria",
      schoolId: "ec20a588-583b-495e-bcd1-afd05fb9050e",
      schoolName: "Greenwood Academy",
      schoolEmail: "greenwood@school.edu",
      schoolPhone: "+1-217-555-0100",
      schoolAddress: "123 Education Lane",
      schoolEMISNumber: "EMIS-2024-001",
      schoolCityName: "Damascus",
      schoolStateName: "Damascus",
      schoolTypeName: "Secondary",
      schoolAcademicYearId: "49031d13-404b-4cc1-9649-11c033a6d6ac",
      academicYearName: "2026-2027",
      academicYearStartDate: DateTime.parse("2026-09-01"),
      academicYearEndDate: DateTime.parse("2027-08-31"),
      qualificationName: "Undergraduate Degree",
      qualificationType: "UnderGraduate",
      designation: "Teacher",
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _teacherHeader(context, teacher),

          const SizedBox(height: 28),

          TeacherInfoForm(
            details: teacher,
          ),
        ],
      ),
    );
  }
}
