import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

class DoctorSupplyItem extends DoctorItem implements Equatable {
  final String unit_en;
  final String unit_ar;
  final double reorder_quantity;
  final double transfer_quantity;
  final double buying_price;
  final double selling_price;
  final bool notify_on_reorder_quantity;

  const DoctorSupplyItem({
    required super.id,
    required super.name_en,
    required super.name_ar,
    required this.unit_en,
    required this.unit_ar,
    required this.reorder_quantity,
    required this.transfer_quantity,
    required this.buying_price,
    required this.selling_price,
    required this.notify_on_reorder_quantity,
    super.item = ProfileSetupItem.supplies,
  });

  DoctorSupplyItem copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    String? unit_en,
    String? unit_ar,
    double? reorder_quantity,
    double? transfer_quantity,
    double? buying_price,
    double? selling_price,
    bool? notify_on_reorder_quantity,
  }) {
    return DoctorSupplyItem(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      unit_en: unit_en ?? this.unit_en,
      unit_ar: unit_ar ?? this.unit_ar,
      reorder_quantity: reorder_quantity ?? this.reorder_quantity,
      transfer_quantity: transfer_quantity ?? this.transfer_quantity,
      buying_price: buying_price ?? this.buying_price,
      selling_price: selling_price ?? this.selling_price,
      notify_on_reorder_quantity:
          notify_on_reorder_quantity ?? this.notify_on_reorder_quantity,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'unit_en': unit_en,
      'unit_ar': unit_ar,
      'reorder_quantity': reorder_quantity,
      'transfer_quantity': transfer_quantity,
      'buying_price': buying_price,
      'selling_price': selling_price,
      'notify_on_reorder_quantity': notify_on_reorder_quantity,
    };
  }

  factory DoctorSupplyItem.fromJson(Map<String, dynamic> map) {
    return DoctorSupplyItem(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      unit_en: map['unit_en'] as String,
      unit_ar: map['unit_ar'] as String,
      reorder_quantity: map['reorder_quantity'] as double,
      transfer_quantity: map['transfer_quantity'] as double,
      buying_price: map['buying_price'] as double,
      selling_price: map['selling_price'] as double,
      notify_on_reorder_quantity: map['notify_on_reorder_quantity'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name_en,
    name_ar,
    unit_en,
    unit_ar,
    reorder_quantity,
    buying_price,
    selling_price,
    notify_on_reorder_quantity,
  ];

  @override
  bool get stringify => true;
}
