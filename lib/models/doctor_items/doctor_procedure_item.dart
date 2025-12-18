import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

class DoctorProcedureItem extends DoctorItem implements Equatable {
  final int price;
  final int discount_percentage;

  const DoctorProcedureItem({
    required super.id,
    required super.name_en,
    required super.name_ar,
    required this.price,
    required this.discount_percentage,
    super.item = ProfileSetupItem.procedures,
  });

  DoctorProcedureItem copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    int? price,
    int? discount_percentage,
  }) {
    return DoctorProcedureItem(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      price: price ?? this.price,
      discount_percentage: discount_percentage ?? this.discount_percentage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'price': price,
      'discount_percentage': discount_percentage,
    };
  }

  factory DoctorProcedureItem.fromJson(Map<String, dynamic> map) {
    return DoctorProcedureItem(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      price: map['price'] as int,
      discount_percentage: map['discount_percentage'] as int,
    );
  }

  @override
  List<Object?> get props => [id, name_en, name_ar, price, discount_percentage];

  @override
  bool get stringify => true;
}
