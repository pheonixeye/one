import 'package:equatable/equatable.dart';

import 'package:one/models/bookkeeping/bookkeeping_direction.dart';
import 'package:one/models/patient.dart';
import 'package:pocketbase/pocketbase.dart';

class BookkeepingItem extends Equatable {
  final String id;
  final String item_name;
  final String item_id;
  final String collection_id;
  final String added_by;
  final String updated_by;
  final double amount;
  final BookkeepingDirection type; //in,out,none;
  final String update_reason;
  final bool auto_add;
  final DateTime created;
  final String visit_id;
  final DateTime? visit_date;
  final String visit_data_id;
  final String procedure_id;
  final String patient_id;
  final String supply_movement_id;
  final Patient? patient;

  const BookkeepingItem({
    required this.id,
    required this.item_name,
    required this.item_id,
    required this.collection_id,
    required this.added_by,
    required this.updated_by,
    required this.amount,
    required this.type,
    required this.update_reason,
    required this.auto_add,
    required this.created,
    required this.visit_id,
    required this.visit_date,
    required this.visit_data_id,
    required this.procedure_id,
    required this.patient_id,
    required this.supply_movement_id,
    this.patient,
  });

  BookkeepingItem copyWith({
    String? id,
    String? item_name,
    String? item_id,
    String? collection_id,
    String? added_by,
    String? updated_by,
    double? amount,
    BookkeepingDirection? type,
    String? update_reason,
    bool? auto_add,
    DateTime? created,
    String? visit_id,
    DateTime? visit_date,
    String? visit_data_id,
    String? procedure_id,
    String? patient_id,
    String? supply_movement_id,
  }) {
    return BookkeepingItem(
      id: id ?? this.id,
      item_name: item_name ?? this.item_name,
      item_id: item_id ?? this.item_id,
      collection_id: collection_id ?? this.collection_id,
      added_by: added_by ?? this.added_by,
      updated_by: updated_by ?? this.updated_by,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      update_reason: update_reason ?? this.update_reason,
      auto_add: auto_add ?? this.auto_add,
      created: created ?? this.created,
      visit_id: visit_id ?? this.visit_id,
      visit_date: visit_date ?? this.visit_date,
      visit_data_id: visit_data_id ?? this.visit_data_id,
      procedure_id: procedure_id ?? this.procedure_id,
      patient_id: patient_id ?? this.patient_id,
      supply_movement_id: supply_movement_id ?? this.supply_movement_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'item_name': item_name,
      'item_id': item_id,
      'collection_id': collection_id,
      'added_by': added_by,
      'updated_by': updated_by,
      'amount': amount,
      'type': type.value,
      'update_reason': update_reason,
      'auto_add': auto_add,
      'created': created.toIso8601String(),
      'visit_id': visit_id,
      'visit_date': visit_date?.toIso8601String(),
      'visit_data_id': visit_data_id,
      'procedure_id': procedure_id,
      'patient_id': patient_id,
      'supply_movement_id': supply_movement_id,
      'patient': patient?.toJson(),
    };
  }

  factory BookkeepingItem.fromJson(Map<String, dynamic> map) {
    return BookkeepingItem(
      id: map['id'] as String,
      item_name: map['item_name'] as String,
      item_id: map['item_id'] as String,
      collection_id: map['collection_id'] as String,
      added_by: map['added_by'] as String,
      updated_by: map['updated_by'] as String,
      amount: map['amount'] as double,
      type: BookkeepingDirection.fromString(map['type'] as String),
      update_reason: map['update_reason'] as String,
      auto_add: map['auto_add'] as bool,
      created: DateTime.parse(map['created'] as String),
      visit_id: map['visit_id'] as String,
      visit_date: DateTime.tryParse(map['visit_date'] as String),
      visit_data_id: map['visit_data_id'] as String,
      procedure_id: map['procedure_id'] as String,
      patient_id: map['patient_id'] as String,
      supply_movement_id: map['supply_movement_id'] as String,
      patient:
          (map['patient'] == null || map['patient'].isEmpty) //HACK
          ? null
          : Patient.fromJson(map['patient'] as Map<String, dynamic>),
    );
  }

  factory BookkeepingItem.fromRecordModel(RecordModel record) {
    return BookkeepingItem.fromJson({
      ...record.toJson(),
      'patient': record.get<RecordModel>('expand.patient_id').toJson(),
    });
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      item_name,
      item_id,
      collection_id,
      added_by,
      updated_by,
      amount,
      type,
      update_reason,
      auto_add,
      created,
      visit_id,
      visit_date,
      visit_data_id,
      procedure_id,
      patient_id,
      supply_movement_id,
      patient,
    ];
  }
}
