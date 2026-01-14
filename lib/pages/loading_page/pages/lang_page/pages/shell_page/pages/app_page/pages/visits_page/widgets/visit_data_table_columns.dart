import 'package:one/extensions/loc_ext.dart';
import 'package:flutter/material.dart';

List<DataColumn> buildDataColumns(BuildContext context) {
  return [
    DataColumn(label: Text(context.loc.number)),
    DataColumn(label: Text(context.loc.patientName)),
    DataColumn(label: Text(context.loc.doctor)),
    DataColumn(label: Text(context.loc.attendanceStatus)),
    DataColumn(label: Text(context.loc.visitDate)),
    DataColumn(label: Text(context.loc.visitType)),
    DataColumn(label: Text(context.loc.clinic)),
    DataColumn(label: Text(context.loc.clinicShift)),
    DataColumn(label: Text(context.loc.addedBy)),
  ];
}
