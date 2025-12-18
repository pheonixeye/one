import 'package:one/models/bookkeeping/bookkeeping_name.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/supplies/clinic_inventory_item.dart';
import 'package:one/models/supplies/supply_movement.dart';
import 'package:one/models/supplies/supply_movement_dto.dart';
import 'package:one/models/supplies/supply_movement_type.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/providers/px_auth.dart';

class SupplyMovementTransformer {
  const SupplyMovementTransformer();

  ClinicInventoryItem toClinicInventoryItem(
    SupplyMovement supplyMovement,
    ClinicInventoryItem inventoryItem,
  ) {
    double? _newAvailableQuantity;

    if (supplyMovement.movement_type == SupplyMovementType.IN_OUT.name) {
      _newAvailableQuantity =
          inventoryItem.available_quantity - supplyMovement.movement_quantity;
    } else if (supplyMovement.movement_type == SupplyMovementType.OUT_IN.name) {
      _newAvailableQuantity =
          inventoryItem.available_quantity + supplyMovement.movement_quantity;
    } else {
      //SupplyMovementType.IN_IN
      //todo: when to add && when to subtract
      if (supplyMovement.reason.contains('من')) {
        _newAvailableQuantity =
            inventoryItem.available_quantity - supplyMovement.movement_quantity;
      } else {
        _newAvailableQuantity =
            inventoryItem.available_quantity + supplyMovement.movement_quantity;
      }
    }

    if (supplyMovement.reason == BookkeepingName.visit_supplies_add.name) {
      _newAvailableQuantity =
          inventoryItem.available_quantity - supplyMovement.movement_quantity;
    } else if (supplyMovement.reason ==
        BookkeepingName.visit_supplies_remove.name) {
      _newAvailableQuantity =
          inventoryItem.available_quantity + supplyMovement.movement_quantity;
    }

    return ClinicInventoryItem(
      id: inventoryItem.id,
      clinic_id: supplyMovement.clinic.id,
      supply_item: supplyMovement.supply_item,
      available_quantity: _newAvailableQuantity,
    );
  }

  SupplyMovementDto fromSuppliesOfVisit(
    VisitData data,
    DoctorSupplyItem item,
    double quantity_change,
  ) {
    String? _reason;
    String? _movment_type;

    if (quantity_change.isNegative) {
      _reason = BookkeepingName.visit_supplies_remove.name;
      _movment_type = SupplyMovementType.OUT_IN.en;
    } else if (!quantity_change.isNegative) {
      _reason = BookkeepingName.visit_supplies_add.name;
      _movment_type = SupplyMovementType.IN_OUT.en;
    }

    return SupplyMovementDto(
      id: '',
      clinic_id: data.clinic_id,
      supply_item_id: item.id,
      movement_type: _movment_type!,
      related_visit_id: data.visit_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      reason: _reason!,
      movement_amount: quantity_change * item.selling_price,
      movement_quantity: quantity_change.abs(),
      number_of_updates: 0,
      auto_add: true,
    );
  }
}
