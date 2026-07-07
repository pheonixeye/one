import 'package:equatable/equatable.dart';

import 'package:one/models/doctor_items/profile_setup_item.dart';

class PiSupplyItem extends Equatable {
  final String id;
  final String doc_id;
  final String name_en;
  final String name_ar;
  final String unit_en;
  final String unit_ar;
  final double reorder_quantity;
  final double transfer_quantity;
  final double buying_price;
  final double selling_price;
  final bool notify_on_reorder_quantity;

  const PiSupplyItem({
    required this.id,
    required this.doc_id,
    required this.name_en,
    required this.name_ar,
    required this.unit_en,
    required this.unit_ar,
    required this.reorder_quantity,
    required this.transfer_quantity,
    required this.buying_price,
    required this.selling_price,
    required this.notify_on_reorder_quantity,
  });
  final ProfileSetupItem item = ProfileSetupItem.supplies;

  PiSupplyItem copyWith({
    String? id,
    String? doc_id,
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
    return PiSupplyItem(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
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

  factory PiSupplyItem.fromJson(Map<String, dynamic> map) {
    return PiSupplyItem(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
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
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      doc_id,
      name_en,
      name_ar,
      unit_en,
      unit_ar,
      reorder_quantity,
      transfer_quantity,
      buying_price,
      selling_price,
      notify_on_reorder_quantity,
    ];
  }
}
