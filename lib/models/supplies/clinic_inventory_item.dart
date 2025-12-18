import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';

class ClinicInventoryItem extends Equatable {
  final String id;
  final String clinic_id;
  final DoctorSupplyItem supply_item;
  final double available_quantity;

  const ClinicInventoryItem({
    required this.id,
    required this.clinic_id,
    required this.supply_item,
    required this.available_quantity,
  });

  ClinicInventoryItem copyWith({
    String? id,
    String? clinic_id,
    DoctorSupplyItem? supply_item,
    double? available_quantity,
  }) {
    return ClinicInventoryItem(
      id: id ?? this.id,
      clinic_id: clinic_id ?? this.clinic_id,
      supply_item: supply_item ?? this.supply_item,
      available_quantity: available_quantity ?? this.available_quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinic_id': clinic_id,
      'supply_id': supply_item.id,
      'available_quantity': available_quantity,
    };
  }

  factory ClinicInventoryItem.fromJson(Map<String, dynamic> map) {
    return ClinicInventoryItem(
      id: map['id'] as String,
      clinic_id: map['clinic_id'] as String,
      supply_item: DoctorSupplyItem.fromJson(
        map['supply_id'] as Map<String, dynamic>,
      ),
      available_quantity: map['available_quantity'] as double,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, clinic_id, supply_item, available_quantity];

  factory ClinicInventoryItem.fromRecordModel(RecordModel e) {
    return ClinicInventoryItem(
      id: e.id,
      clinic_id: e.getStringValue('clinic_id'),
      supply_item: DoctorSupplyItem.fromJson(
        e.get<RecordModel>('expand.supply_id').toJson(),
      ),
      available_quantity: e.getDoubleValue('available_quantity'),
    );
  }
}
