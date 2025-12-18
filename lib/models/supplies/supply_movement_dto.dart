import 'package:equatable/equatable.dart';

class SupplyMovementDto extends Equatable {
  final String id;
  final String clinic_id;
  final String supply_item_id;
  final String movement_type;
  final String related_visit_id;
  final String added_by_id;
  final String updated_by_id;
  final String reason;
  final double movement_amount;
  final double movement_quantity;
  final int number_of_updates;
  final bool auto_add;

  const SupplyMovementDto({
    required this.id,
    required this.clinic_id,
    required this.supply_item_id,
    required this.movement_type,
    required this.related_visit_id,
    required this.added_by_id,
    required this.updated_by_id,
    required this.reason,
    required this.movement_amount,
    required this.movement_quantity,
    required this.number_of_updates,
    required this.auto_add,
  });

  SupplyMovementDto copyWith({
    String? id,
    String? clinic_id,
    String? supply_item_id,
    String? movement_type,
    String? related_visit_id,
    String? added_by_id,
    String? updated_by_id,
    String? reason,
    double? movement_amount,
    double? movement_quantity,
    int? number_of_updates,
    bool? auto_add,
  }) {
    return SupplyMovementDto(
      id: id ?? this.id,
      clinic_id: clinic_id ?? this.clinic_id,
      supply_item_id: supply_item_id ?? this.supply_item_id,
      movement_type: movement_type ?? this.movement_type,
      related_visit_id: related_visit_id ?? this.related_visit_id,
      added_by_id: added_by_id ?? this.added_by_id,
      updated_by_id: updated_by_id ?? this.updated_by_id,
      reason: reason ?? this.reason,
      movement_amount: movement_amount ?? this.movement_amount,
      movement_quantity: movement_quantity ?? this.movement_quantity,
      auto_add: auto_add ?? this.auto_add,
      number_of_updates: number_of_updates ?? this.number_of_updates,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinic_id': clinic_id,
      'supply_item_id': supply_item_id,
      'movement_type': movement_type,
      'related_visit_id': related_visit_id,
      'added_by_id': added_by_id,
      'updated_by_id': updated_by_id,
      'reason': reason,
      'movement_amount': movement_amount,
      'movement_quantity': movement_quantity,
      'auto_add': auto_add,
      'number_of_updates': number_of_updates,
    };
  }

  factory SupplyMovementDto.fromJson(Map<String, dynamic> map) {
    return SupplyMovementDto(
      id: map['id'] as String,
      clinic_id: map['clinic_id'] as String,
      supply_item_id: map['supply_item_id'] as String,
      movement_type: map['movement_type'] as String,
      related_visit_id: map['related_visit_id'] as String,
      added_by_id: map['added_by_id'] as String,
      updated_by_id: map['updated_by_id'] as String,
      reason: map['reason'] as String,
      movement_amount: map['movement_amount'] as double,
      movement_quantity: map['movement_quantity'] as double,
      auto_add: map['auto_add'] as bool,
      number_of_updates: map['number_of_updates'] as int,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      clinic_id,
      supply_item_id,
      movement_type,
      related_visit_id,
      added_by_id,
      updated_by_id,
      reason,
      movement_amount,
      movement_quantity,
      auto_add,
      number_of_updates,
    ];
  }
}
