import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:one/models/doctor_items/doctor_drug_item.dart';
import 'package:one/models/doctor_items/doctor_lab_item.dart';
import 'package:one/models/doctor_items/doctor_procedure_item.dart';
import 'package:one/models/doctor_items/doctor_rad_item.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/pc_form.dart';
import 'package:one/models/visit_data/visit_form_item.dart';

class VisitData extends Equatable {
  final String id;
  final String clinic_id;
  final String visit_id;
  final Patient patient;
  final List<DoctorDrugItem> drugs;
  final List<DoctorLabItem> labs;
  final List<DoctorRadItem> rads;
  final List<DoctorProcedureItem> procedures;
  final List<DoctorSupplyItem> supplies;
  final List<PcForm> forms;
  final List<VisitFormItem> forms_data;
  final Map drug_data;
  final Map<String, dynamic>? supplies_data;

  const VisitData({
    required this.id,
    required this.clinic_id,
    required this.visit_id,
    required this.patient,
    required this.drugs,
    required this.labs,
    required this.rads,
    required this.procedures,
    required this.supplies,
    required this.forms,
    required this.forms_data,
    required this.drug_data,
    required this.supplies_data,
  });

  VisitData copyWith({
    String? id,
    String? clinic_id,
    String? visit_id,
    Patient? patient,
    List<DoctorDrugItem>? drugs,
    List<DoctorLabItem>? labs,
    List<DoctorRadItem>? rads,
    List<DoctorProcedureItem>? procedures,
    List<DoctorSupplyItem>? supplies,
    List<PcForm>? forms,
    List<VisitFormItem>? forms_data,
    Map? drug_data,
    Map<String, dynamic>? supplies_data,
  }) {
    return VisitData(
      id: id ?? this.id,
      clinic_id: clinic_id ?? this.clinic_id,
      visit_id: visit_id ?? this.visit_id,
      patient: patient ?? this.patient,
      drugs: drugs ?? this.drugs,
      labs: labs ?? this.labs,
      rads: rads ?? this.rads,
      procedures: procedures ?? this.procedures,
      supplies: supplies ?? this.supplies,
      forms: forms ?? this.forms,
      forms_data: forms_data ?? this.forms_data,
      drug_data: drug_data ?? this.drug_data,
      supplies_data: supplies_data ?? this.supplies_data,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinic_id': clinic_id,
      'visit_id': visit_id,
      'patient': patient.toJson(),
      'drugs': drugs.map((x) => x.toJson()).toList(),
      'labs': labs.map((x) => x.toJson()).toList(),
      'rads': rads.map((x) => x.toJson()).toList(),
      'procedures': procedures.map((x) => x.toJson()).toList(),
      'supplies': supplies.map((x) => x.toJson()).toList(),
      'forms': forms.map((x) => x.toJson()).toList(),
      'forms_data': forms_data.map((e) => e.toJson()).toList(),
      'drug_data': drug_data,
      'supplies_data': supplies_data,
    };
  }

  factory VisitData.fromJson(Map<String, dynamic> map) {
    return VisitData(
      id: map['id'] as String,
      clinic_id: map['clinic_id'] as String,
      visit_id: map['visit_id'] as String,
      patient: Patient.fromJson(map['patient_id']),
      drugs: List<DoctorDrugItem>.from(
        (map['drugs'] as List<dynamic>).map<DoctorDrugItem>(
          (x) => DoctorDrugItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
      labs: List<DoctorLabItem>.from(
        (map['labs'] as List<dynamic>).map<DoctorLabItem>(
          (x) => DoctorLabItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
      rads: List<DoctorRadItem>.from(
        (map['rads'] as List<dynamic>).map<DoctorRadItem>(
          (x) => DoctorRadItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
      procedures: List<DoctorProcedureItem>.from(
        (map['procedures'] as List<dynamic>).map<DoctorProcedureItem>(
          (x) => DoctorProcedureItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
      supplies: List<DoctorSupplyItem>.from(
        (map['supplies'] as List<dynamic>).map<DoctorSupplyItem>(
          (x) => DoctorSupplyItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
      forms: List<PcForm>.from(
        (map['forms'] as List<dynamic>).map<PcForm>(
          (x) => PcForm.fromJson(x as Map<String, dynamic>),
        ),
      ),
      forms_data: (map['forms_data'] as List<dynamic>)
          .map((e) => VisitFormItem.fromJson(e))
          .toList(),
      drug_data: Map.from((map['drug_data'] as Map)),
      supplies_data: map['supplies_data'] as Map<String, dynamic>?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      clinic_id,
      visit_id,
      patient,
      drugs,
      labs,
      rads,
      procedures,
      supplies,
      forms,
      forms_data,
      drug_data,
      supplies_data,
    ];
  }

  factory VisitData.fromRecordModel(RecordModel e) {
    return VisitData(
      id: e.id,
      clinic_id: e.data['clinic_id'],
      visit_id: e.data['visit_id'],
      patient: Patient.fromJson(
        e.get<RecordModel>('expand.patient_id').toJson(),
      ),
      drugs: e
          .get<List<RecordModel>>('expand.drugs_ids')
          .map((x) => DoctorDrugItem.fromJson(x.toJson()))
          .toList(),
      labs: e
          .get<List<RecordModel>>('expand.labs_ids')
          .map((x) => DoctorLabItem.fromJson(x.toJson()))
          .toList(),
      rads: e
          .get<List<RecordModel>>('expand.rads_ids')
          .map((x) => DoctorRadItem.fromJson(x.toJson()))
          .toList(),
      procedures: e
          .get<List<RecordModel>>('expand.procedures_ids')
          .map((x) => DoctorProcedureItem.fromJson(x.toJson()))
          .toList(),
      supplies: e
          .get<List<RecordModel>>('expand.supplies_ids')
          .map((x) => DoctorSupplyItem.fromJson(x.toJson()))
          .toList(),
      forms:
          (e.toJson()['expand']['forms_data_ids'] as List<dynamic>?)
              ?.map((e) => PcForm.fromJson(e['expand']['form_id']))
              .toList() ??
          [],
      forms_data: e
          .get<List<RecordModel>>('expand.forms_data_ids')
          .map((x) => VisitFormItem.fromJson(x.toJson()))
          .toList(),
      drug_data: e.data['drug_data'],
      supplies_data: e.data['supplies_data'] ?? {},
    );
  }
}
