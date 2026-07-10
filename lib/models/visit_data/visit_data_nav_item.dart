// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/1_clinical_notes_page/clinical_notes_page.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/3_drugs_page/drugs_page.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/2_forms_page/forms_page.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/4_labs_page/labs_page.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/5_rads_page/rads_page.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/6_procedures_page/procedures_page.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/7_supplies_page/supplies_page.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/8_prescription_page/prescription_page.dart';

class VisitDataNavItem extends Equatable {
  final String title;
  final Icon icon;
  final Icon selectedIcon;
  final Widget page;

  const VisitDataNavItem({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });

  @override
  List<Object?> get props => [title, icon, selectedIcon, page];

  static List<VisitDataNavItem> items(BuildContext context) => [
    VisitDataNavItem(
      title: context.loc.clinicalNotes,
      icon: const Icon(FontAwesomeIcons.notesMedical),
      selectedIcon: const Icon(FontAwesomeIcons.noteSticky),
      page: VisitClinicalNotesPage(),
    ),
    VisitDataNavItem(
      title: context.loc.visitForms,
      icon: const Icon(Icons.edit_document),
      selectedIcon: const Icon(Icons.edit),
      page: VisitFormsPage(),
    ),
    VisitDataNavItem(
      title: context.loc.visitDrugs,
      icon: const Icon(FontAwesomeIcons.prescriptionBottle),
      selectedIcon: const Icon(FontAwesomeIcons.prescription),
      page: VisitDrugsPage(),
    ),
    VisitDataNavItem(
      title: context.loc.visitLabs,
      icon: const Icon(FontAwesomeIcons.droplet),
      selectedIcon: const Icon(FontAwesomeIcons.notesMedical),
      page: VisitLabsPage(),
    ),
    VisitDataNavItem(
      title: context.loc.visitRads,
      icon: const Icon(FontAwesomeIcons.radiation),
      selectedIcon: const Icon(FontAwesomeIcons.laptopMedical),
      page: VisitRadsPage(),
    ),
    VisitDataNavItem(
      title: context.loc.visitProcedures,
      icon: const Icon(FontAwesomeIcons.userDoctor),
      selectedIcon: const Icon(FontAwesomeIcons.kitMedical),
      page: VisitProceduresPage(),
    ),
    VisitDataNavItem(
      title: context.loc.visitSupplies,
      icon: const Icon(FontAwesomeIcons.warehouse),
      selectedIcon: const Icon(FontAwesomeIcons.handHoldingMedical),
      page: VisitSuppliesPage(),
    ),
    VisitDataNavItem(
      title: context.loc.visitPrescription,
      icon: const Icon(FontAwesomeIcons.fileMedical),
      selectedIcon: const Icon(FontAwesomeIcons.prescription),
      page: VisitPrescriptionPage(),
    ),
  ];
}
