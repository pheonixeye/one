import 'package:one/core/api/constants_api.dart';
import 'package:one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:one/models/bookkeeping/bookkeeping_name.dart';
import 'package:one/models/doctor_items/doctor_procedure_item.dart';
import 'package:one/models/supplies/supply_movement.dart';
import 'package:one/models/supplies/supply_movement_type.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';

class BookkeepingTransformer {
  BookkeepingTransformer({required this.item_id, required this.collection_id});

  final _appConstants = PxAppConstants(api: ConstantsApi());
  final String item_id;
  final String collection_id;

  late final _attended_id = _appConstants.attended.id;
  late final _not_attended_id = _appConstants.notAttended.id;
  late final _consultation_id = _appConstants.consultation.id;
  late final _followup_id = _appConstants.followup.id;
  late final _procedure_id = _appConstants.procedure.id;

  BookkeepingItemDto fromVisitCreate(Visit visit) {
    late double _bk_item_amount;

    if (visit.visit_status.id == _not_attended_id) {
      _bk_item_amount = 0;
    } else {
      if (visit.visit_type.id == _consultation_id) {
        _bk_item_amount = visit.clinic.consultation_fees.toDouble();
      }
      if (visit.visit_type.id == _followup_id) {
        _bk_item_amount = visit.clinic.followup_fees.toDouble();
      }
      if (visit.visit_type.id == _procedure_id) {
        _bk_item_amount = visit.clinic.procedure_fees.toDouble();
      }
    }
    final _item = BookkeepingItemDto(
      id: '',
      item_name: BookkeepingName.visit_create.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: 'in',
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }

  BookkeepingItemDto fromVisitUpdate(Visit old_visit, Visit updated_visit) {
    //TODO: error prone logic - needs to improve by a long shot
    BookkeepingName _item_name = BookkeepingName.visit_no_update;
    late final String _type;
    double _bk_item_amount = 0;

    if (old_visit.visit_status.id == _attended_id &&
        updated_visit.visit_status.id == _not_attended_id) {
      //old : attended - new : not-attended
      if (old_visit.visit_type.id == _consultation_id) {
        _bk_item_amount = (-old_visit.clinic.consultation_fees).toDouble();
      }
      if (old_visit.visit_type.id == _followup_id) {
        _bk_item_amount = (-old_visit.clinic.followup_fees).toDouble();
      }
      if (old_visit.visit_type.id == _procedure_id) {
        _bk_item_amount = (-old_visit.clinic.procedure_fees).toDouble();
      }
      _item_name = BookkeepingName.visit_attendance_update_not_attended;
    } else if (old_visit.visit_status.id == _not_attended_id &&
        updated_visit.visit_status.id == _attended_id) {
      //old : not-attended - new : attended
      if (old_visit.visit_type.id == _consultation_id) {
        _bk_item_amount = (old_visit.clinic.consultation_fees).toDouble();
      }
      if (old_visit.visit_type.id == _followup_id) {
        _bk_item_amount = (old_visit.clinic.followup_fees).toDouble();
      }
      if (old_visit.visit_type.id == _procedure_id) {
        _bk_item_amount = (old_visit.clinic.procedure_fees).toDouble();
      }
      _item_name = BookkeepingName.visit_attendance_update_attended;
    } else if (old_visit.visit_status.id == _not_attended_id &&
        updated_visit.visit_status.id == _not_attended_id) {
      //old : not-attended - new : not-attended
      _item_name = BookkeepingName.visit_type_update;
      _bk_item_amount = 0;
    } else if (old_visit.visit_status.id == _attended_id &&
        updated_visit.visit_status.id == _attended_id) {
      //old : attended - new : attended
      if (old_visit.visit_type.id == _consultation_id &&
          updated_visit.visit_type.id == _followup_id) {
        //consultation => followup
        _item_name = BookkeepingName.visit_type_update_followup;
        _bk_item_amount =
            (old_visit.clinic.followup_fees -
                    old_visit.clinic.consultation_fees)
                .toDouble();
      }
      if (old_visit.visit_type.id == _consultation_id &&
          updated_visit.visit_type.id == _procedure_id) {
        //consultation => procedure
        _item_name = BookkeepingName.visit_type_update_procedure;
        _bk_item_amount =
            (old_visit.clinic.procedure_fees -
                    old_visit.clinic.consultation_fees)
                .toDouble();
      }
      if (old_visit.visit_type.id == _followup_id &&
          updated_visit.visit_type.id == _consultation_id) {
        //followup => consultation
        _item_name = BookkeepingName.visit_type_update_consultation;
        _bk_item_amount =
            (old_visit.clinic.consultation_fees -
                    old_visit.clinic.followup_fees)
                .toDouble();
      }
      if (old_visit.visit_type.id == _followup_id &&
          updated_visit.visit_type.id == _procedure_id) {
        //followup => procedure
        _item_name = BookkeepingName.visit_type_update_procedure;
        _bk_item_amount =
            (old_visit.clinic.procedure_fees - old_visit.clinic.followup_fees)
                .toDouble();
      }
      if (old_visit.visit_type.id == _procedure_id &&
          updated_visit.visit_type.id == _consultation_id) {
        //procedure => consultation
        _item_name = BookkeepingName.visit_type_update_consultation;
        _bk_item_amount =
            (old_visit.clinic.consultation_fees -
                    old_visit.clinic.procedure_fees)
                .toDouble();
      }
      if (old_visit.visit_type.id == _procedure_id &&
          updated_visit.visit_type.id == _followup_id) {
        //procedure => followup
        _item_name = BookkeepingName.visit_type_update_followup;
        _bk_item_amount =
            (old_visit.clinic.followup_fees - old_visit.clinic.procedure_fees)
                .toDouble();
      }
    }

    _type = _bk_item_amount > 0
        ? 'in'
        : _bk_item_amount == 0
        ? 'none'
        : 'out';

    final _item = BookkeepingItemDto(
      id: '',
      item_name: _item_name.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: _type,
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }

  BookkeepingItemDto fromVisitDataAddProcedure(
    VisitData visit_data,
    DoctorProcedureItem procedure,
  ) {
    final BookkeepingName _item_name = BookkeepingName.visit_procedure_add;
    final String _type = 'in';
    final double _bk_item_amount =
        procedure.price -
        ((procedure.price * procedure.discount_percentage) / 100);

    final _item = BookkeepingItemDto(
      id: '',
      item_name: _item_name.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: _type,
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }

  BookkeepingItemDto fromVisitDataRemoveProcedure(
    VisitData visit_data,
    DoctorProcedureItem procedure,
  ) {
    final BookkeepingName _item_name = BookkeepingName.visit_procedure_remove;
    final String _type = 'out';
    final double _bk_item_amount =
        -(procedure.price -
            ((procedure.price * procedure.discount_percentage) / 100));

    final _item = BookkeepingItemDto(
      id: '',
      item_name: _item_name.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: _type,
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }

  BookkeepingItemDto fromManualSupplyMovement(SupplyMovement supplyMovement) {
    final BookkeepingName _item_name = switch (SupplyMovementType.fromString(
      supplyMovement.movement_type,
    )) {
      SupplyMovementType.OUT_IN => BookkeepingName.supplies_movement_add_manual,
      SupplyMovementType.IN_OUT =>
        BookkeepingName.supplies_movement_remove_manual,
      SupplyMovementType.IN_IN =>
        BookkeepingName.supplies_movement_no_update_manual,
    };

    final String _type = switch (SupplyMovementType.fromString(
      supplyMovement.movement_type,
    )) {
      SupplyMovementType.OUT_IN => 'in',
      SupplyMovementType.IN_OUT => 'out',
      SupplyMovementType.IN_IN => 'none',
    };

    final double _bk_item_amount = switch (SupplyMovementType.fromString(
      supplyMovement.movement_type,
    )) {
      SupplyMovementType.OUT_IN =>
        -supplyMovement.supply_item.buying_price *
            supplyMovement.movement_quantity,
      SupplyMovementType.IN_OUT =>
        supplyMovement.supply_item.selling_price *
            supplyMovement.movement_quantity,
      SupplyMovementType.IN_IN => 0,
    };

    final _item = BookkeepingItemDto(
      id: '',
      item_name: _item_name.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: _type,
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }

  BookkeepingItemDto fromVisitAddSupplyMovement(SupplyMovement supplyMovement) {
    final BookkeepingName _item_name = BookkeepingName.visit_supplies_add;

    final String _type = 'out';

    final double _bk_item_amount = supplyMovement.movement_amount;

    final _item = BookkeepingItemDto(
      id: '',
      item_name: _item_name.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: _type,
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }

  BookkeepingItemDto fromVisitRemoveSupplyMovement(
    SupplyMovement supplyMovement,
  ) {
    final BookkeepingName _item_name = BookkeepingName.visit_supplies_remove;

    final String _type = 'in';

    final double _bk_item_amount = -supplyMovement.movement_amount;

    final _item = BookkeepingItemDto(
      id: '',
      item_name: _item_name.name,
      item_id: item_id,
      collection_id: collection_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      amount: _bk_item_amount,
      type: _type,
      update_reason: '',
      auto_add: true,
    );

    return _item;
  }
}
