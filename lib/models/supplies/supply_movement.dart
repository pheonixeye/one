import 'package:equatable/equatable.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';

class SupplyMovement extends Equatable {
  final String id;
  final Clinic clinic;
  final DoctorSupplyItem supply_item;
  final String? visit_id;
  final String added_by;
  final String? updated_by;
  final String movement_type;
  final String reason;
  final double movement_quantity;
  final double movement_amount;
  final bool auto_add;
  final int number_of_updates;
  final DateTime created;
  final Visit? visit;

  const SupplyMovement({
    required this.id,
    required this.clinic,
    required this.supply_item,
    this.visit_id,
    this.updated_by,
    required this.added_by,
    required this.movement_type,
    required this.reason,
    required this.movement_quantity,
    required this.movement_amount,
    required this.auto_add,
    required this.number_of_updates,
    required this.created,
    this.visit,
  });

  SupplyMovement copyWith({
    String? id,
    Clinic? clinic,
    DoctorSupplyItem? supply_item,
    String? visit_id,
    String? added_by,
    String? updated_by,
    String? movement_type,
    String? reason,
    double? movement_quantity,
    double? movement_amount,
    bool? auto_add,
    int? number_of_updates,
    DateTime? created,
  }) {
    return SupplyMovement(
      id: id ?? this.id,
      clinic: clinic ?? this.clinic,
      supply_item: supply_item ?? this.supply_item,
      visit_id: visit_id ?? this.visit_id,
      added_by: added_by ?? this.added_by,
      updated_by: updated_by ?? this.updated_by,
      movement_type: movement_type ?? this.movement_type,
      reason: reason ?? this.reason,
      movement_quantity: movement_quantity ?? this.movement_quantity,
      movement_amount: movement_amount ?? this.movement_amount,
      auto_add: auto_add ?? this.auto_add,
      number_of_updates: number_of_updates ?? this.number_of_updates,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinic': clinic.toJson(),
      'supply_item': supply_item.toJson(),
      'related_visit_id': visit_id,
      'added_by': added_by,
      'updated_by': updated_by,
      'movement_type': movement_type,
      'reason': reason,
      'movement_quantity': movement_quantity,
      'movement_amount': movement_amount,
      'auto_add': auto_add,
      'number_of_updated': number_of_updates,
      'created': created.toIso8601String(),
    };
  }

  factory SupplyMovement.fromJson(Map<String, dynamic> map) {
    return SupplyMovement(
      id: map['id'] as String,
      clinic: Clinic.fromJson(map['clinic'] as Map<String, dynamic>),
      supply_item: DoctorSupplyItem.fromJson(
        map['supply_item'] as Map<String, dynamic>,
      ),
      visit_id: map['related_visit_id'] as String?,
      updated_by: map['updated_by'] as String?,
      added_by: map['added_by'] as String,
      movement_type: map['movement_type'] as String,
      reason: map['reason'] as String,
      movement_quantity: map['movement_quantity'] as double,
      movement_amount: map['movement_amount'] as double,
      auto_add: map['auto_add'] as bool,
      number_of_updates: map['number_of_updated'] as int,
      created: DateTime.parse(map['created'] as String),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      clinic,
      supply_item,
      visit_id,
      movement_type,
      added_by,
      reason,
      movement_quantity,
      movement_amount,
      auto_add,
      updated_by,
      number_of_updates,
      created,
      visit,
    ];
  }

  factory SupplyMovement.fromRecordModel(RecordModel e) {
    return SupplyMovement(
      id: e.id,
      clinic: Clinic.fromJson(e.get<RecordModel>('expand.clinic_id').toJson()),
      supply_item: DoctorSupplyItem.fromJson(
        e.get<RecordModel>('expand.supply_item_id').toJson(),
      ),
      added_by: e.getStringValue('added_by'),
      movement_type: e.getStringValue('movement_type'),
      reason: e.getStringValue('reason'),
      movement_quantity: e.getDoubleValue('movement_quantity'),
      movement_amount: e.getDoubleValue('movement_amount'),
      auto_add: e.getBoolValue('auto_add'),
      visit_id: e.get<String?>('related_visit_id'),
      updated_by: e.get<String?>('updated_by'),
      number_of_updates: e.getIntValue('number_of_updates'),
      created: DateTime.parse(e.getStringValue('created')),
      visit: Visit.fromJson(
        e.get<RecordModel>('expand.related_visit_id').toJson(),
      ),
    );
  }
}
