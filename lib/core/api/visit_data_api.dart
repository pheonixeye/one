import 'package:one/annotations/pb_annotations.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/supply_movement_api.dart';
import 'package:one/core/logic/bookkeeping_transformer.dart';
import 'package:one/core/logic/supply_movement_transformer.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/models/visit_data/visit_data.dart';
import 'package:one/models/visit_data/visit_form_item.dart';

@PbData()
class VisitDataApi {
  final String visit_id;

  VisitDataApi({required this.visit_id});

  late final String collection = 'visit__data';

  late final String forms_data_collection = 'visit__formdata';

  final String _expand =
      'patient_id, labs_ids, rads_ids, procedures_ids, drugs_ids, supplies_ids, forms_data_ids, forms_data_ids.form_id';

  Future<ApiResult<VisitData>> fetchVisitData() async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getFirstListItem("visit_id = '$visit_id'", expand: _expand);

      final _visitData = VisitData.fromRecordModel(_result);

      return ApiDataResult<VisitData>(data: _visitData);
    } on ClientException catch (e) {
      return ApiErrorResult<VisitData>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> attachForm(VisitData visit_data, VisitFormItem form_data) async {
    final _formCreateRequest = await PocketbaseHelper.pbData
        .collection(forms_data_collection)
        .create(body: form_data.toJson());

    await PocketbaseHelper.pbData
        .collection(collection)
        .update(
          visit_data.id,
          body: {'forms_data_ids+': _formCreateRequest.id},
        );
  }

  Future<void> detachForm(VisitData visit_data, VisitFormItem form_data) async {
    await PocketbaseHelper.pbData
        .collection(forms_data_collection)
        .delete(form_data.id);

    await PocketbaseHelper.pbData
        .collection(collection)
        .update(visit_data.id, body: {'forms_data_ids-': form_data.id});
  }

  Future<void> updateFormData(
    VisitData visit_data,
    VisitFormItem form_data,
  ) async {
    await PocketbaseHelper.pbData
        .collection(forms_data_collection)
        .update(form_data.id, body: form_data.toJson());
  }

  Future<void> addDrugsToVisit(
    VisitData visit_data,
    List<String> drugs_ids,
  ) async {
    await PocketbaseHelper.pbData
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
    await PocketbaseHelper.pbData
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
    await PocketbaseHelper.pbData
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
    await PocketbaseHelper.pbData
        .collection(collection)
        .update(
          visit_data.id,
          body: {
            'drug_data': {...visit_data.drug_data, drug_id: drug_dose},
          },
        );
  }

  Future<void> addToItemList(
    VisitData visit_data,
    String item_id,
    ProfileSetupItem setupItem,
  ) async {
    final Map<String, dynamic> _update = switch (setupItem) {
      ProfileSetupItem.drugs || ProfileSetupItem.documents => {},
      ProfileSetupItem.labs => {'labs_ids+': item_id},
      ProfileSetupItem.rads => {'rads_ids+': item_id},
      ProfileSetupItem.procedures => {'procedures_ids+': item_id},
      ProfileSetupItem.supplies => {'supplies_ids+': item_id},
    };

    final _response = await PocketbaseHelper.pbData
        .collection(collection)
        .update(visit_data.id, body: _update, expand: _expand);
    //todo: parse data
    final _visit_data = VisitData.fromRecordModel(_response);

    if (setupItem == ProfileSetupItem.procedures) {
      //todo: initialize transformer
      final _bk_transformer = BookkeepingTransformer(
        item_id: _visit_data.id,
        collection_id: collection,
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
      ProfileSetupItem.drugs || ProfileSetupItem.documents => {},
      ProfileSetupItem.labs => {'labs_ids-': item_id},
      ProfileSetupItem.rads => {'rads_ids-': item_id},
      ProfileSetupItem.procedures => {'procedures_ids-': item_id},
      ProfileSetupItem.supplies => {'supplies_ids-': item_id},
    };

    final _response = await PocketbaseHelper.pbData
        .collection(collection)
        .update(visit_data.id, body: _update, expand: _expand);

    //todo: parse data
    final _visit_data = VisitData.fromRecordModel(_response);

    if (setupItem == ProfileSetupItem.procedures) {
      //todo: initialize transformer
      final _bk_transformer = BookkeepingTransformer(
        item_id: _visit_data.id,
        collection_id: collection,
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

  Future<void> updateSupplyItemQuantity(
    VisitData visit_data,
    DoctorSupplyItem item,
    double new_quantity,
    double quantity_change,
  ) async {
    final _update = {
      'supplies_data': {
        ...visit_data.supplies_data ?? {},
        item.id: new_quantity,
      },
    };
    final _response = await PocketbaseHelper.pbData
        .collection(collection)
        .update(visit_data.id, body: _update, expand: _expand);

    final _visit_data = VisitData.fromRecordModel(_response);

    final _supplyMovementApi = SupplyMovementApi();
    // dprint('quantity_change ==>> $quantity_change');
    final _movement = SupplyMovementTransformer().fromSuppliesOfVisit(
      _visit_data,
      item,
      quantity_change,
    );

    await _supplyMovementApi.addSupplyMovements([_movement]);
  }
}
