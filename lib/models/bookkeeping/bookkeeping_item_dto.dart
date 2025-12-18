import 'package:equatable/equatable.dart';

class BookkeepingItemDto extends Equatable {
  final String id;
  final String item_name;
  final String item_id;
  final String collection_id;
  final String added_by_id;
  final String updated_by_id;
  final double amount;
  final String type; //in,out;
  final String update_reason;
  final bool auto_add;

  const BookkeepingItemDto({
    required this.id,
    required this.item_name,
    required this.item_id,
    required this.collection_id,
    required this.added_by_id,
    required this.updated_by_id,
    required this.amount,
    required this.type,
    required this.update_reason,
    required this.auto_add,
  });

  BookkeepingItemDto copyWith({
    String? id,
    String? item_name,
    String? item_id,
    String? collection_id,
    String? added_by_id,
    String? updated_by_id,
    double? amount,
    String? type,
    String? update_reason,
    bool? auto_add,
  }) {
    return BookkeepingItemDto(
      id: id ?? this.id,
      item_name: item_name ?? this.item_name,
      item_id: item_id ?? this.item_id,
      collection_id: collection_id ?? this.collection_id,
      added_by_id: added_by_id ?? this.added_by_id,
      updated_by_id: updated_by_id ?? this.updated_by_id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      update_reason: update_reason ?? this.update_reason,
      auto_add: auto_add ?? this.auto_add,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'item_name': item_name,
      'item_id': item_id,
      'collection_id': collection_id,
      'added_by_id': added_by_id,
      'updated_by_id': updated_by_id,
      'amount': amount,
      'type': type,
      'update_reason': update_reason,
      'auto_add': auto_add,
    };
  }

  factory BookkeepingItemDto.fromJson(Map<String, dynamic> map) {
    return BookkeepingItemDto(
      id: map['id'] as String,
      item_name: map['item_name'] as String,
      item_id: map['item_id'] as String,
      collection_id: map['collection_id'] as String,
      added_by_id: map['added_by_id'] as String,
      updated_by_id: map['updated_by_id'] as String,
      amount: map['amount'] as double,
      type: map['type'] as String,
      update_reason: map['update_reason'] as String,
      auto_add: map['auto_add'] as bool,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      item_name,
      item_id,
      collection_id,
      added_by_id,
      updated_by_id,
      amount,
      type,
      update_reason,
      auto_add,
    ];
  }
}
