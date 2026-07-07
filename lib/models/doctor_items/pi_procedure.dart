import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/profile_setup_item.dart';

class PiProcedure extends Equatable {
  final String id;
  final String doc_id;
  final String name_en;
  final String name_ar;
  final int price;
  final int discount_percentage;

  const PiProcedure({
    required this.id,
    required this.doc_id,
    required this.name_en,
    required this.name_ar,
    required this.price,
    required this.discount_percentage,
  });
  final ProfileSetupItem item = ProfileSetupItem.procedures;

  PiProcedure copyWith({
    String? id,
    String? doc_id,
    String? name_en,
    String? name_ar,
    int? price,
    int? discount_percentage,
  }) {
    return PiProcedure(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      price: price ?? this.price,
      discount_percentage: discount_percentage ?? this.discount_percentage,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'name_en': name_en,
      'name_ar': name_ar,
      'price': price,
      'discount_percentage': discount_percentage,
    };
  }

  factory PiProcedure.fromJson(Map<String, dynamic> map) {
    return PiProcedure(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      price: map['price'] as int,
      discount_percentage: map['discount_percentage'] as int,
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
      price,
      discount_percentage,
    ];
  }
}
