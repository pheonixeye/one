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

// DataRow buildVisitDataRow(
//   BuildContext context, {
//   required ConcisedVisit x,
//   required int index,
// }) {
//   final l = context.read<PxLocale>();
//   final a = context.read<PxAppConstants>();
//   final c = context.read<PxClinics>();
//   final d = context.read<PxDoctor>();
//   return DataRow(
//     cells: [
//       DataCell(
//         Center(
//           child: Text('${index + 1}'.toArabicNumber(context)),
//         ),
//       ),
//       //todo
//       DataCell(
//         VisitOptionsBtn(
//           concisedVisit: x,
//         ),
//       ),
//       DataCell(
//         Center(
//           child: Builder(
//             builder: (context) {
//               final _doctor = d.allDoctors?.firstWhere((e) => e.id == x.doc_id);
//               return Text(
//                 l.isEnglish ? _doctor?.name_en ?? '' : _doctor?.name_ar ?? '',
//               );
//             },
//           ),
//         ),
//       ),
//       DataCell(
//         Builder(
//           builder: (context) {
//             final _isAttended = x.visit_status_id == a.attended.id;
//             return Center(
//               child: Icon(
//                 _isAttended ? Icons.check : Icons.close,
//                 color: _isAttended ? Colors.green : Colors.red,
//               ),
//             );
//           },
//         ),
//       ),
//       DataCell(
//         Center(
//           child: Text(
//             DateFormat('dd - MM - yyyy', l.lang)
//                 .format(DateTime.parse(x.visit_date)),
//           ),
//         ),
//       ),
//       DataCell(
//         Center(
//           child: Builder(
//             builder: (context) {
//               final _visitType = a.constants?.visitType
//                   .firstWhere((e) => e.id == x.visit_type_id);
//               return Text(
//                 l.isEnglish
//                     ? _visitType?.name_en ?? ''
//                     : _visitType?.name_ar ?? '',
//               );
//             },
//           ),
//         ),
//       ),
//       DataCell(
//         Center(
//           child: Builder(
//             builder: (context) {
//               final _clinic = (c.result as ApiDataResult<List<Clinic>>)
//                   .data
//                   .firstWhere((e) => e.id == x.clinic_id);
//               return Text(
//                 l.isEnglish ? _clinic.name_en : _clinic.name_ar,
//               );
//             },
//           ),
//         ),
//       ),
//       DataCell(
//         Center(
//           child: Text(
//             x.visit_schedule.formattedShift(context),
//           ),
//         ),
//       ),
//       DataCell(
//         Center(
//           child: Text(
//             x.added_by.name,
//           ),
//         ),
//       ),
//     ],
//   );
// }
