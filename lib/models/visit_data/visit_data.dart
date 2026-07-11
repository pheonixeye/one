import 'package:equatable/equatable.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/doctor.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:one/models/doctor_items/pi_drug.dart';
import 'package:one/models/doctor_items/pi_lab.dart';
import 'package:one/models/doctor_items/pi_procedure.dart';
import 'package:one/models/doctor_items/pi_rads.dart';
import 'package:one/models/doctor_items/pi_supply_item.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/pk_form.dart';
import 'package:one/models/visit_data/visit_form_item.dart';

class VisitData extends Equatable {
  final String id;
  final String clinic_id;
  final String visit_id;
  final Patient patient;
  final List<PiDrug> drugs;
  final List<PiLab> labs;
  final List<PiRad> rads;
  final List<PiProcedure> procedures;
  final List<PiSupplyItem> supplies;
  final List<PkForm> forms;
  final List<VisitFormItem> forms_data;
  final Map drug_data;
  final Map<String, dynamic>? supplies_data;
  final Doctor? doctor;
  final Visit? visit;
  final Clinic? clinic;

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
    this.doctor,
    this.visit,
    this.clinic,
  });

  VisitData copyWith({
    String? id,
    String? clinic_id,
    String? visit_id,
    Patient? patient,
    List<PiDrug>? drugs,
    List<PiLab>? labs,
    List<PiRad>? rads,
    List<PiProcedure>? procedures,
    List<PiSupplyItem>? supplies,
    List<PkForm>? forms,
    List<VisitFormItem>? forms_data,
    Map? drug_data,
    Map<String, dynamic>? supplies_data,
    Doctor? doctor,
    Visit? visit,
    Clinic? clinic,
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
      doctor: doctor ?? this.doctor,
      visit: visit ?? this.visit,
      clinic: clinic ?? this.clinic,
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
      drugs: List<PiDrug>.from(
        (map['drugs'] as List<dynamic>).map<PiDrug>(
          (x) => PiDrug.fromJson(x as Map<String, dynamic>),
        ),
      ),
      labs: List<PiLab>.from(
        (map['labs'] as List<dynamic>).map<PiLab>(
          (x) => PiLab.fromJson(x as Map<String, dynamic>),
        ),
      ),
      rads: List<PiRad>.from(
        (map['rads'] as List<dynamic>).map<PiRad>(
          (x) => PiRad.fromJson(x as Map<String, dynamic>),
        ),
      ),
      procedures: List<PiProcedure>.from(
        (map['procedures'] as List<dynamic>).map<PiProcedure>(
          (x) => PiProcedure.fromJson(x as Map<String, dynamic>),
        ),
      ),
      supplies: List<PiSupplyItem>.from(
        (map['supplies'] as List<dynamic>).map<PiSupplyItem>(
          (x) => PiSupplyItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
      forms: List<PkForm>.from(
        (map['forms'] as List<dynamic>).map<PkForm>(
          (x) => PkForm.fromJson(x as Map<String, dynamic>),
        ),
      ),
      forms_data: (map['forms_data'] as List<dynamic>)
          .map((e) => VisitFormItem.fromJson(e))
          .toList(),
      drug_data: Map.from((map['drug_data'] as Map)),
      supplies_data: map['supplies_data'] as Map<String, dynamic>?,
      doctor: Doctor.fromJson(map['doctor'] as Map<String, dynamic>),
      visit: Visit.fromJson(map['visit'] as Map<String, dynamic>),
      clinic: Clinic.fromJson(map['clinic'] as Map<String, dynamic>),
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
    late final List<PkForm> _forms;
    try {
      _forms = (e.toJson()['expand']['forms_data_ids'] as List<dynamic>)
          .map(
            (f) => PkForm.fromJson({
              ...f['expand']['form_id'],
              'fields': [
                ...f['expand']['form_id']['expand']['fields'],
              ],
            }),
          )
          .toList();
    } catch (e) {
      _forms = [];
    }
    return VisitData(
      id: e.id,
      clinic_id: e.data['clinic_id'],
      visit_id: e.data['visit_id'],
      patient: Patient.fromJson(
        e.get<RecordModel>('expand.patient_id').toJson(),
      ),
      drugs: e
          .get<List<RecordModel>>('expand.drugs_ids')
          .map((x) => PiDrug.fromJson(x.toJson()))
          .toList(),
      labs: e
          .get<List<RecordModel>>('expand.labs_ids')
          .map((x) => PiLab.fromJson(x.toJson()))
          .toList(),
      rads: e
          .get<List<RecordModel>>('expand.rads_ids')
          .map((x) => PiRad.fromJson(x.toJson()))
          .toList(),
      procedures: e
          .get<List<RecordModel>>('expand.procedures_ids')
          .map((x) => PiProcedure.fromJson(x.toJson()))
          .toList(),
      supplies: e
          .get<List<RecordModel>>('expand.supplies_ids')
          .map((x) => PiSupplyItem.fromJson(x.toJson()))
          .toList(),
      forms: _forms,
      forms_data: e
          .get<List<RecordModel>>('expand.forms_data_ids')
          .map((x) => VisitFormItem.fromJson(x.toJson()))
          .toList(),
      drug_data: e.data['drug_data'],
      supplies_data: e.data['supplies_data'] ?? {},
      doctor: Doctor.fromJson(
        e.get<RecordModel>('expand.doc_id').toJson(),
      ),
      visit: Visit.fromJson(
        e.get<RecordModel>('expand.visit_id').toJson(),
      ),
      clinic: Clinic.fromJson(
        e.get<RecordModel>('expand.clinic_id').toJson(),
      ),
    );
  }
}
