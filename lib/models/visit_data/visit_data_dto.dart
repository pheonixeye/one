import 'package:equatable/equatable.dart';

class VisitDataDto extends Equatable {
  final String id;
  final String visit_id;
  final String patient_id;
  final String clinic_id;
  final List<String> labs_ids;
  final List<String> rads_ids;
  final List<String> drugs_ids;
  final List<String> procedures_ids;
  final List<String> supplies_ids;
  final List<String> forms_data_ids;
  final Map<String, dynamic> forms_data;
  final Map<String, dynamic> drug_data;
  final Map<String, dynamic> supplies_data;

  const VisitDataDto({
    required this.id,
    required this.visit_id,
    required this.patient_id,
    required this.clinic_id,
    required this.labs_ids,
    required this.rads_ids,
    required this.drugs_ids,
    required this.procedures_ids,
    required this.supplies_ids,
    required this.forms_data_ids,
    required this.supplies_data,
    required this.forms_data,
    required this.drug_data,
  });

  VisitDataDto copyWith({
    String? id,
    String? visit_id,
    String? patient_id,
    String? clinic_id,
    List<String>? labs_ids,
    List<String>? rads_ids,
    List<String>? drugs_ids,
    List<String>? procedures_ids,
    List<String>? supplies_ids,
    List<String>? forms_data_ids,
    Map<String, dynamic>? forms_data,
    Map<String, dynamic>? supplies_data,
    Map<String, dynamic>? drug_data,
  }) {
    return VisitDataDto(
      id: id ?? this.id,
      visit_id: visit_id ?? this.visit_id,
      patient_id: patient_id ?? this.patient_id,
      clinic_id: clinic_id ?? this.clinic_id,
      labs_ids: labs_ids ?? this.labs_ids,
      rads_ids: rads_ids ?? this.rads_ids,
      drugs_ids: drugs_ids ?? this.drugs_ids,
      procedures_ids: procedures_ids ?? this.procedures_ids,
      supplies_ids: supplies_ids ?? this.supplies_ids,
      supplies_data: supplies_data ?? this.supplies_data,
      forms_data_ids: forms_data_ids ?? this.forms_data_ids,
      forms_data: forms_data ?? this.forms_data,
      drug_data: drug_data ?? this.drug_data,
    );
  }

  factory VisitDataDto.initial({
    required String visit_id,
    required String patient_id,
    required String clinic_id,
  }) {
    return VisitDataDto(
      id: '',
      visit_id: visit_id,
      patient_id: patient_id,
      clinic_id: clinic_id,
      labs_ids: [],
      rads_ids: [],
      drugs_ids: [],
      procedures_ids: [],
      supplies_ids: [],
      forms_data_ids: [],
      forms_data: {},
      drug_data: {},
      supplies_data: {},
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'visit_id': visit_id,
      'patient_id': patient_id,
      'clinic_id': clinic_id,
      'labs_ids': labs_ids,
      'rads_ids': rads_ids,
      'drugs_ids': drugs_ids,
      'procedures_ids': procedures_ids,
      'supplies_ids': supplies_ids,
      'forms_data_ids': forms_data_ids,
      'forms_data': forms_data,
      'drug_data': drug_data,
      'supplies_data': supplies_data,
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      visit_id,
      patient_id,
      clinic_id,
      labs_ids,
      rads_ids,
      drugs_ids,
      procedures_ids,
      supplies_ids,
      supplies_data,
      forms_data_ids,
      forms_data,
      drug_data,
    ];
  }
}
