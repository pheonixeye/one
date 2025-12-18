import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/models/bookkeeping/bookkeeping_direction.dart';
import 'package:one/models/user/user_dto.dart';

class BookkeepingItem extends Equatable {
  final String id;
  final String item_name;
  final String item_id;
  final String collection_id;
  final UserDto added_by;
  final UserDto? updated_by;
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
    this.updated_by,
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
    UserDto? added_by,
    UserDto? updated_by,
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
      'added_by': added_by.toJson(),
      'updated_by': updated_by?.toJson(),
      'amount': amount,
      'type': type.value,
      'update_reason': update_reason,
      'auto_add': auto_add,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory BookkeepingItem.fromJson(Map<String, dynamic> map) {
    return BookkeepingItem(
      id: map['id'] as String,
      item_name: map['item_name'] as String,
      item_id: map['item_id'] as String,
      collection_id: map['collection_id'] as String,
      added_by: UserDto.fromJson(map['added_by'] as Map<String, dynamic>),
      updated_by: map['updated_by'] != null
          ? UserDto.fromJson(map['updated_by'] as Map<String, dynamic>)
          : null,
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

  factory BookkeepingItem.fromRecordModel(RecordModel e) {
    return BookkeepingItem(
      id: e.id,
      item_name: e.getStringValue('item_name'),
      item_id: e.getStringValue('item_id'),
      collection_id: e.getStringValue('collection_id'),
      amount: e.getDoubleValue('amount'),
      type: BookkeepingDirection.fromString(e.getStringValue('type')),
      update_reason: e.getStringValue('update_reason'),
      auto_add: e.getBoolValue('auto_add'),
      created: DateTime.parse(e.getStringValue('created')),
      added_by: UserDto.fromJson({
        'id': e.get<RecordModel>('expand.added_by_id').id,
        ...e.get<RecordModel>('expand.added_by_id').toJson(),
      }),
      updated_by:
          (e.get<String?>('updated_by_id') == null ||
              e.get<String>('updated_by_id').isEmpty)
          ? null
          : UserDto.fromJson({
              'id': e.get<RecordModel>('expand.updated_by_id').id,
              ...e.get<RecordModel>('expand.updated_by_id').toJson(),
            }),
    );
  }
}
