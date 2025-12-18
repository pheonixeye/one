import 'package:equatable/equatable.dart';

enum PrescriptionPaperSize {
  a5,
  a4;

  factory PrescriptionPaperSize.fromString(String value) {
    return switch (value) {
      'a4' => a4,
      'a5' => a5,
      _ => throw UnimplementedError(),
    };
  }
}

class ItemDetail implements Equatable {
  final String name_en;
  final String name_ar;
  final double x_coord;
  final double y_coord;

  const ItemDetail({
    required this.name_en,
    required this.name_ar,
    required this.x_coord,
    required this.y_coord,
  });

  ItemDetail copyWith({
    String? name_en,
    String? name_ar,
    double? x_coord,
    double? y_coord,
  }) {
    return ItemDetail(
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      x_coord: x_coord ?? this.x_coord,
      y_coord: y_coord ?? this.y_coord,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name_en': name_en,
      'name_ar': name_ar,
      'x_coord': x_coord,
      'y_coord': y_coord,
    };
  }

  factory ItemDetail.fromJson(Map<String, dynamic> map) {
    return ItemDetail(
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      x_coord: double.parse(map['x_coord'].toString()),
      y_coord: double.parse(map['y_coord'].toString()),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name_en,
      name_ar,
      x_coord,
      y_coord,
    ];
  }
}

class PrescriptionDetails implements Equatable {
  final Map<String, ItemDetail> details;

  const PrescriptionDetails({
    required this.details,
  });

  factory PrescriptionDetails.initial() {
    return PrescriptionDetails(
      details: {
        'patient_name': ItemDetail(
          name_en: 'Patient Name',
          name_ar: 'اسم المريض',
          x_coord: 10,
          y_coord: 0,
        ),
        'visit_date': ItemDetail(
          name_en: 'Visit Date',
          name_ar: 'تاريخ الزيارة',
          x_coord: 10,
          y_coord: 50,
        ),
        'visit_type': ItemDetail(
          name_en: 'Visit Type',
          name_ar: 'نوع الزيارة',
          x_coord: 10,
          y_coord: 100,
        ),
        'visit_labs': ItemDetail(
          name_en: 'Visit Labs',
          name_ar: 'التحاليل',
          x_coord: 10,
          y_coord: 150,
        ),
        'visit_rads': ItemDetail(
          name_en: 'Visit Rads',
          name_ar: 'الاشاعات',
          x_coord: 10,
          y_coord: 200,
        ),
        'visit_procedures': ItemDetail(
          name_en: 'Visit Procedures',
          name_ar: 'الاجرائات',
          x_coord: 10,
          y_coord: 250,
        ),
        'visit_drugs': ItemDetail(
          name_en: 'Visit Drugs',
          name_ar: 'الادوية',
          x_coord: 10,
          y_coord: 300,
        ),
        'medical_report': ItemDetail(
          name_en: 'Medical Report',
          name_ar: 'تقرير طبي',
          x_coord: 10,
          y_coord: 350,
        ),
        'referral_report': ItemDetail(
          name_en: 'Referral Report',
          name_ar: 'خطاب تحويل',
          x_coord: 10,
          y_coord: 400,
        ),
        'doctor_name': ItemDetail(
          name_en: 'Doctor Name',
          name_ar: 'اسم الطبيب',
          x_coord: 10,
          y_coord: 450,
        ),
      },
    );
  }

  PrescriptionDetails copyWith({
    Map<String, ItemDetail>? item_details,
  }) {
    return PrescriptionDetails(
      details: item_details ?? details,
    );
  }

  Map<String, dynamic> toJson() => {
        'details': Map.fromEntries(
          details.entries.map(
            (e) => MapEntry(
              e.key,
              e.value.toJson(),
            ),
          ),
        ),
      };

  factory PrescriptionDetails.fromJson(Map<String, dynamic> map) {
    return PrescriptionDetails(
      details: Map.fromEntries(
        (map['details'] as Map<String, dynamic>).entries.map(
              (e) => MapEntry(e.key, ItemDetail.fromJson(e.value)),
            ),
      ),
    );
  }

  PrescriptionDetails updateItemDetail({
    required String key,
    required double x_coord,
    required double y_coord,
  }) {
    if (details[key] == null) {
      return this;
    }
    return copyWith(
      item_details: {
        ...details,
        key: details[key]!.copyWith(
          x_coord: x_coord,
          y_coord: y_coord,
        ),
      },
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        details,
      ];
}
