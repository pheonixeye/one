import 'package:equatable/equatable.dart';
import 'package:one/models/bookkeeping/bookkeeping_direction.dart';

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
    );
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
    ];
  }
}
