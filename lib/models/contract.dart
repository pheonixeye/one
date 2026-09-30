import 'package:equatable/equatable.dart';
import 'package:one/models/translatable.dart';

class Contract extends Equatable {
  final String id;
  final String doc_id;
  final String name_en;
  final String name_ar;
  final bool is_active;
  final ContractType contract_type;
  final ContractData contract_data;

  const Contract({
    required this.id,
    required this.doc_id,
    required this.name_en,
    required this.name_ar,
    required this.is_active,
    required this.contract_type,
    required this.contract_data,
  });

  Contract copyWith({
    String? id,
    String? doc_id,
    String? name_en,
    String? name_ar,
    bool? is_active,
    ContractType? contract_type,
    ContractData? contract_data,
  }) {
    return Contract(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      is_active: is_active ?? this.is_active,
      contract_type: contract_type ?? this.contract_type,
      contract_data: contract_data ?? this.contract_data,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'name_en': name_en,
      'name_ar': name_ar,
      'is_active': is_active,
      'contract_type': contract_type.type,
      'contract_data': contract_data.toJson(),
    };
  }

  factory Contract.fromJson(Map<String, dynamic> map) {
    final _contract_type = ContractType.fromDbType(
      map['contract_type'] as String,
    );
    return Contract(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      is_active: map['is_active'] as bool,
      contract_type: _contract_type,
      contract_data: ContractData.fromContractType(
        type: _contract_type,
        map: map['contract_data'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      doc_id,
      name_en,
      name_ar,
      is_active,
      contract_type,
      contract_data,
    ];
  }
}

enum ContractType {
  not_specified(
    type: 'not_specified',
    name_en: 'Not Specified',
    name_ar: 'غير محدد',
  ),
  booking_application(
    type: 'booking_application',
    name_en: 'Booking Application',
    name_ar: 'منصة حجز مرضي',
  ),
  insurance_company(
    type: 'insurance_company',
    name_en: 'Insurance Company',
    name_ar: 'تعاقد / شركة تامين / جهة تامين',
  );

  final String type;
  final String name_en;
  final String name_ar;

  const ContractType({
    required this.type,
    required this.name_en,
    required this.name_ar,
  });

  factory ContractType.fromDbType(String? type) {
    return switch (type) {
      'booking_application' => ContractType.booking_application,
      'insurance_company' => ContractType.insurance_company,
      _ => ContractType.not_specified,
    };
  }
}

abstract class ContractData with EquatableMixin {
  const ContractData();

  factory ContractData.fromContractType({
    required ContractType type,
    required Map<String, dynamic> map,
  }) {
    return switch (type) {
      ContractType.not_specified => ContractDataNotSpecified(),
      ContractType.booking_application => ContractDataBookingApplication(
        consultation_fees: map['consultation_fees'],
        followup_fees: map['followup_fees'],
        is_fixed_fees: map['is_fixed_fees'],
        application_fees: map['application_fees'],
        application_percentage: map['application_percentage'],
      ),
      ContractType.insurance_company => ContractDataInsuranceCompany(
        consultation_fees: map['consultation_fees'],
        followup_fees: map['followup_fees'],
        patient_pays_percentage: map['patient_pays_percentage'],
        requires_approval_for_each_visit:
            map['requires_approval_for_each_visit'],
        patient_percent: map['patient_percent'],
      ),
    };
  }

  Map<String, dynamic> toJson();

  Map<String, Translatable> forWidgets();
}

class ContractDataNotSpecified extends ContractData {
  @override
  List<Object?> get props => [];
  @override
  Map<String, dynamic> toJson() => {};

  @override
  Map<String, Translatable> forWidgets() => {};
}

class ContractDataBookingApplication extends ContractData {
  final num consultation_fees;
  final num followup_fees;
  final bool is_fixed_fees;
  final num? application_fees;
  final num? application_percentage;

  ContractDataBookingApplication({
    required this.consultation_fees,
    required this.followup_fees,
    required this.is_fixed_fees,
    this.application_fees,
    this.application_percentage,
  });
  // : assert(
  //          application_fees != null || application_percentage != null,
  //          'Either Fees Or Percentage Must Be Set.',
  //        )
  @override
  List<Object?> get props => [
    consultation_fees,
    followup_fees,
    is_fixed_fees,
    application_fees,
    application_percentage,
  ];

  ContractDataBookingApplication copyWith({
    num? consultation_fees,
    num? followup_fees,
    bool? is_fixed_fees,
    num? application_fees,
    num? application_percentage,
  }) {
    return ContractDataBookingApplication(
      consultation_fees: consultation_fees ?? this.consultation_fees,
      followup_fees: followup_fees ?? this.followup_fees,
      is_fixed_fees: is_fixed_fees ?? this.is_fixed_fees,
      application_fees: application_fees ?? this.application_fees,
      application_percentage:
          application_percentage ?? this.application_percentage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'consultation_fees': consultation_fees,
      'followup_fees': followup_fees,
      'is_fixed_fees': is_fixed_fees,
      'application_fees': application_fees,
      'application_percentage': application_percentage,
    };
  }

  factory ContractDataBookingApplication.fromJson(Map<String, dynamic> map) {
    return ContractDataBookingApplication(
      consultation_fees: map['consultation_fees'] as num,
      followup_fees: map['followup_fees'] as num,
      is_fixed_fees: map['is_fixed_fees'] as bool,
      application_fees: map['application_fees'] != null
          ? map['application_fees'] as num
          : null,
      application_percentage: map['application_percentage'] != null
          ? map['application_percentage'] as num
          : null,
    );
  }

  num? get calculatedClinicConsultationFees {
    if (is_fixed_fees && application_fees != null) {
      return consultation_fees - application_fees!;
    } else if (!is_fixed_fees && application_percentage != null) {
      return consultation_fees * application_percentage! / 100;
    } else {
      return null;
    }
  }

  @override
  Map<String, Translatable> forWidgets() => {
    'consultation_fees': Translatable(
      en: 'Consultation Fees',
      ar: 'رسوم الكشف',
    ),
    'followup_fees': Translatable(
      en: 'Follow Up Fees',
      ar: 'رسوم الاستشارة',
    ),
    'is_fixed_fees': Translatable(
      en: 'Application Fees Are Fixed Not Percentage',
      ar: 'منصة الحجز تتعامل بسعر ثابت و ليس نسبة',
    ),
    'application_fees': Translatable(
      en: 'Application Fees In Pounds',
      ar: 'رسوم منصة الحجز بالجنيه',
    ),
    'application_percentage': Translatable(
      en: 'Application Percentage %',
      ar: 'نسبة رسوم منصة الحجز',
    ),
  };
}

class ContractDataInsuranceCompany extends ContractData {
  final num consultation_fees;
  final num followup_fees;
  final bool patient_pays_percentage;
  final num? patient_percent;
  final bool requires_approval_for_each_visit;
  ContractDataInsuranceCompany({
    required this.consultation_fees,
    required this.followup_fees,
    required this.patient_pays_percentage,
    this.patient_percent,
    required this.requires_approval_for_each_visit,
  });
  // : assert(
  //          (patient_pays_percentage == true && patient_percent != null) ||
  //              (!patient_pays_percentage),
  //          'If Patient Pays A Percentage, This Percentace Has To Be Set',
  //        )
  ContractDataInsuranceCompany copyWith({
    num? consultation_fees,
    num? followup_fees,
    bool? patient_pays_percentage,
    num? patient_percent,
    bool? requires_approval_for_each_visit,
  }) {
    return ContractDataInsuranceCompany(
      consultation_fees: consultation_fees ?? this.consultation_fees,
      followup_fees: followup_fees ?? this.followup_fees,
      patient_pays_percentage:
          patient_pays_percentage ?? this.patient_pays_percentage,
      patient_percent: patient_percent ?? this.patient_percent,
      requires_approval_for_each_visit:
          requires_approval_for_each_visit ??
          this.requires_approval_for_each_visit,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'consultation_fees': consultation_fees,
      'followup_fees': followup_fees,
      'patient_pays_percentage': patient_pays_percentage,
      'patient_percent': patient_percent,
      'requires_approval_for_each_visit': requires_approval_for_each_visit,
    };
  }

  factory ContractDataInsuranceCompany.fromJson(Map<String, dynamic> map) {
    return ContractDataInsuranceCompany(
      consultation_fees: map['consultation_fees'] as num,
      followup_fees: map['followup_fees'] as num,
      patient_pays_percentage: map['patient_pays_percentage'] as bool,
      patient_percent: map['patient_percent'] != null
          ? map['patient_percent'] as num
          : null,
      requires_approval_for_each_visit:
          map['requires_approval_for_each_visit'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    consultation_fees,
    followup_fees,
    patient_pays_percentage,
    patient_percent,
    requires_approval_for_each_visit,
  ];
  @override
  Map<String, Translatable> forWidgets() => {
    'consultation_fees': Translatable(
      en: 'Consultation Fees',
      ar: 'رسوم الكشف',
    ),
    'followup_fees': Translatable(
      en: 'Follow Up Fees',
      ar: 'رسوم الاستشارة',
    ),
    'patient_pays_percentage': Translatable(
      en: 'Patient Pays A Percentage Per Visit %',
      ar: 'يتحمل المريض نسبة من رسوم الزيارة %',
    ),
    'patient_percent': Translatable(
      en: 'Patient Percentage Per Visit %',
      ar: 'نسبة تحمل المريض من رسوم الزيارة %',
    ),
    'requires_approval_for_each_visit': Translatable(
      en: 'Requires Approval For Each Visit',
      ar: 'يحتاج موافقة من الجهة علي كل زيارة',
    ),
  };
}
