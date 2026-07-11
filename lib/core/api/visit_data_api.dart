import 'package:one/annotations/pb_annotations.dart';
import 'package:one/models/doctor_items/pi_supply_item.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/supply_movement_api.dart';
import 'package:one/core/logic/bookkeeping_transformer.dart';
import 'package:one/core/logic/supply_movement_transformer.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visit_data/visit_form_item.dart';

@PbData()
class VisitDataApi {
  final String visit_id;
  final String added_by;

  VisitDataApi({
    required this.visit_id,
    required this.added_by,
  });

  late final String collection = 'visit__data';

  late final String forms_data_collection = 'visit__formdata';

  final String _expand =
      'patient_id, labs_ids, rads_ids, procedures_ids, drugs_ids, supplies_ids, forms_data_ids, forms_data_ids.form_id, forms_data_ids.form_id.fields';

  Future<ApiResult<VisitData>> fetchVisitData() async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .getFirstListItem("visit_id = '$visit_id'", expand: _expand);
      // prettyPrint(_result);
      final _visitData = VisitData.fromRecordModel(_result);
      // prettyPrint(_visitData);

      return ApiDataResult<VisitData>(data: _visitData);
    } on ClientException catch (e) {
      return ApiErrorResult<VisitData>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> attachForm(VisitData visit_data, VisitFormItem form_data) async {
    final _formCreateRequest = await PocketbaseHelper().pbData
        .collection(forms_data_collection)
        .create(body: form_data.toJson());

    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data.id,
          body: {'forms_data_ids+': _formCreateRequest.id},
        );
  }

  Future<void> detachForm(VisitData visit_data, VisitFormItem form_data) async {
    await PocketbaseHelper().pbData
        .collection(forms_data_collection)
        .delete(form_data.id);

    await PocketbaseHelper().pbData
        .collection(collection)
        .update(visit_data.id, body: {'forms_data_ids-': form_data.id});
  }

  Future<void> updateFormData(
    VisitData visit_data,
    VisitFormItem form_data,
  ) async {
    await PocketbaseHelper().pbData
        .collection(forms_data_collection)
        .update(form_data.id, body: form_data.toJson());
  }

  Future<void> addDrugsToVisit(
    VisitData visit_data,
    List<String> drugs_ids,
  ) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data.id,
          body: {
            'drugs_ids+': [...drugs_ids],
          },
        );
  }

  Future<void> removeDrugsFromVisit(
    VisitData visit_data,
    List<String> drugs_ids,
  ) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data.id,
          body: {
            'drugs_ids-': [...drugs_ids],
          },
        );
  }

  Future<void> updateDrugsListInVisit(
    VisitData visit_data,
    List<String> drugs_ids,
  ) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data.id,
          body: {
            'drugs_ids': [...drugs_ids],
          },
        );
  }

  Future<void> setDrugDose(
    VisitData visit_data,
    String drug_id,
    String drug_dose,
  ) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data.id,
          body: {
            'drug_data': {...visit_data.drug_data, drug_id: drug_dose},
          },
        );
  }

  Future<void> addLabToVisitData({
    required String visit_data_id,
    required String lab_id,
  }) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data_id,
          body: {'labs_ids+': lab_id},
          expand: _expand,
        );
  }

  Future<void> removeLabFromVisitData({
    required String visit_data_id,
    required String lab_id,
  }) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data_id,
          body: {'labs_ids-': lab_id},
          expand: _expand,
        );
  }

  Future<void> addRadToVisitData({
    required String visit_data_id,
    required String rad_id,
  }) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data_id,
          body: {'rads_ids+': rad_id},
          expand: _expand,
        );
  }

  Future<void> removeRadFromVisitData({
    required String visit_data_id,
    required String rad_id,
  }) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data_id,
          body: {'rads_ids-': rad_id},
          expand: _expand,
        );
  }

  Future<void> addProcedureToVisitData({
    required String visit_data_id,
    required String proc_id,
  }) async {
    final _data_update_request = await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data_id,
          body: {'procedures_ids+': proc_id},
          expand: _expand,
        );

    final _visit_data = VisitData.fromRecordModel(_data_update_request);

    final _bk_transformer = BookkeepingTransformer(
      item_id: visit_data_id,
      collection_id: collection,
      added_by: added_by,
    );
    //todo: get added item
    final _added_procedure = _visit_data.procedures.firstWhereOrNull(
      (x) => x.id == proc_id,
    );

    //todo: initialize bk_item
    if (_added_procedure != null) {
      final _item = _bk_transformer.fromVisitDataAddProcedure(
        _visit_data,
        _added_procedure,
      );

      //todo: send bookkeeping request
      await BookkeepingApi().addBookkeepingItem(_item);
    }
  }

  Future<void> removeProcedureFromVisitData({
    required String visit_data_id,
    required String proc_id,
  }) async {
    final _data_update_request = await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data_id,
          body: {'procedures_ids-': proc_id},
          expand: _expand,
        );

    final _visit_data = VisitData.fromRecordModel(_data_update_request);

    final _bk_transformer = BookkeepingTransformer(
      item_id: _visit_data.id,
      collection_id: collection,
      added_by: added_by,
    );
    //todo: get added item
    final _removed_procedure = _visit_data.procedures.firstWhereOrNull(
      (x) => x.id == proc_id,
    );

    //todo: initialize bk_item
    if (_removed_procedure != null) {
      final _item = _bk_transformer.fromVisitDataRemoveProcedure(
        _visit_data,
        _removed_procedure,
      );

      //todo: send bookkeeping request
      await BookkeepingApi().addBookkeepingItem(_item);
    }
  }

  Future<void> addToItemList(
    VisitData visit_data,
    String item_id,
    ProfileSetupItem setupItem,
  ) async {
    final Map<String, dynamic> _update = switch (setupItem) {
      ProfileSetupItem.drugs ||
      ProfileSetupItem.documents ||
      ProfileSetupItem.referrals => {},
      ProfileSetupItem.labs => {'labs_ids+': item_id},
      ProfileSetupItem.rads => {'rads_ids+': item_id},
      ProfileSetupItem.procedures => {'procedures_ids+': item_id},
      ProfileSetupItem.supplies => {'supplies_ids+': item_id},
    };

    final _response = await PocketbaseHelper().pbData
        .collection(collection)
        .update(visit_data.id, body: _update, expand: _expand);
    //todo: parse data
    final _visit_data = VisitData.fromRecordModel(_response);

    if (setupItem == ProfileSetupItem.procedures) {
      //todo: initialize transformer
      final _bk_transformer = BookkeepingTransformer(
        item_id: _visit_data.id,
        collection_id: collection,
        added_by: added_by,
      );
      //todo: get added item
      final _added_procedure = _visit_data.procedures.firstWhereOrNull(
        (x) => x.id == item_id,
      );

      //todo: initialize bk_item
      if (_added_procedure != null) {
        final _item = _bk_transformer.fromVisitDataAddProcedure(
          _visit_data,
          _added_procedure,
        );

        //todo: send bookkeeping request
        await BookkeepingApi().addBookkeepingItem(_item);
      }
    }
  }

  Future<void> removeFromItemList(
    VisitData visit_data,
    String item_id,
    ProfileSetupItem setupItem,
  ) async {
    final Map<String, dynamic> _update = switch (setupItem) {
      ProfileSetupItem.drugs ||
      ProfileSetupItem.documents ||
      ProfileSetupItem.referrals => {},
      ProfileSetupItem.labs => {'labs_ids-': item_id},
      ProfileSetupItem.rads => {'rads_ids-': item_id},
      ProfileSetupItem.procedures => {'procedures_ids-': item_id},
      ProfileSetupItem.supplies => {'supplies_ids-': item_id},
    };

    final _response = await PocketbaseHelper().pbData
        .collection(collection)
        .update(visit_data.id, body: _update, expand: _expand);

    //todo: parse data
    final _visit_data = VisitData.fromRecordModel(_response);

    if (setupItem == ProfileSetupItem.procedures) {
      //todo: initialize transformer
      final _bk_transformer = BookkeepingTransformer(
        item_id: _visit_data.id,
        collection_id: collection,
        added_by: added_by,
      );
      //todo: get added item
      final _removed_procedure = visit_data.procedures.firstWhereOrNull(
        (x) => x.id == item_id,
      );

      //todo: initialize bk_item
      if (_removed_procedure != null) {
        final _item = _bk_transformer.fromVisitDataRemoveProcedure(
          _visit_data,
          _removed_procedure,
        );

        //todo: send bookkeeping request
        await BookkeepingApi().addBookkeepingItem(_item);
      }
    }
  }

  Future<void> addSupplyItemToVisitData({
    required String visit_data_id,
    required String supply_id,
  }) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data_id,
          body: {'supplies_ids+': supply_id},
          expand: _expand,
        );
  }

  Future<void> removeSupplyItemFromVisitData({
    required String visit_data_id,
    required String supply_id,
  }) async {
    await PocketbaseHelper().pbData
        .collection(collection)
        .update(
          visit_data_id,
          body: {'supplies_ids-': supply_id},
          expand: _expand,
        );
  }

  Future<void> updateSupplyItemQuantity(
    VisitData visit_data,
    PiSupplyItem item,
    num new_quantity,
    num quantity_change,
  ) async {
    final _update = {
      'supplies_data': {
        ...visit_data.supplies_data ?? {},
        item.id: new_quantity,
      },
    };
    final _response = await PocketbaseHelper().pbData
        .collection(collection)
        .update(visit_data.id, body: _update, expand: _expand);

    final _visit_data = VisitData.fromRecordModel(_response);

    final _supplyMovementApi = SupplyMovementApi(added_by: added_by);
    // dprint('quantity_change ==>> $quantity_change');
    final _movement = SupplyMovementTransformer(added_by: added_by)
        .fromSuppliesOfVisit(
          _visit_data,
          item,
          quantity_change,
        );

    await _supplyMovementApi.addSupplyMovements([_movement]);
  }
}
