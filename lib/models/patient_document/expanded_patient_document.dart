// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data' show Uint8List;

import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/patient_document_api.dart';
import 'package:equatable/equatable.dart';

import 'package:one/models/app_constants/document_type.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visits/_visit.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class ExpandedPatientDocument extends Equatable {
  final String id;
  final Patient patient;
  final Visit? visit;
  final VisitData? visitData;
  final DocumentType documentType;
  final String document;
  final DateTime created;

  const ExpandedPatientDocument({
    required this.id,
    required this.patient,
    required this.visit,
    required this.visitData,
    required this.documentType,
    required this.document,
    required this.created,
  });

  @override
  List<Object?> get props {
    return [id, patient, visit, visitData, documentType, document, created];
  }

  factory ExpandedPatientDocument.fromRecordModel(RecordModel record) {
    return ExpandedPatientDocument(
      id: record.id,
      patient: Patient.fromJson(
        record.get<RecordModel>('expand.patient_id').toJson(),
      ),
      visit: record.get<RecordModel?>('expand.related_visit_id') == null
          ? null
          : Visit.fromRecordModel(
              record.get<RecordModel?>('expand.related_visit_id')!,
            ),
      visitData:
          record.get<RecordModel?>('expand.related_visit_data_id') == null
          ? null
          : VisitData.fromRecordModel(
              record.get<RecordModel?>('expand.related_visit_data_id')!,
            ),
      documentType: DocumentType.fromJson(
        record.get<RecordModel>('expand.document_type_id').toJson(),
      ),
      document: record.data['document'] as String,
      created: DateTime.parse(record.data['created'] as String),
    );
  }
}

extension ImageUrlOnExpandedPatientDocument on ExpandedPatientDocument {
  String get imageUrl =>
      '${PocketbaseHelper.pbBase.baseURL}/api/files/${PatientDocumentApi.collection}/$id/$document';

  Future<Uint8List> documentUint8List() async {
    final _request = await http.get(Uri.parse(imageUrl));
    return _request.bodyBytes;
  }
}
