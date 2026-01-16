import 'package:intl/intl.dart';
import 'package:one/annotations/pb_annotations.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/clinic_inventory_api.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/logic/bookkeeping_transformer.dart';
import 'package:one/core/logic/supply_movement_transformer.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/functions/first_where_or_null.dart';
import 'package:one/models/supplies/clinic_inventory_item.dart';
import 'package:one/models/supplies/supply_movement.dart';
import 'package:one/models/supplies/supply_movement_dto.dart';

@PbData()
class SupplyMovementApi {
  SupplyMovementApi();

  late final String collection = 'supply__movements';

  final _expandList = [
    'clinic_id',
    'supply_item_id',
    'related_visit_id',
  ];

  late final String _expand = _expandList.join(',');

  Future<ApiResult<List<SupplyMovement>>> addSupplyMovements(
    List<SupplyMovementDto?> dtos,
  ) async {
    try {
      final List<RecordModel> _responseModels = [];

      for (final dto in dtos) {
        if (dto != null) {
          final _response = await PocketbaseHelper.pbData
              .collection(collection)
              .create(body: dto.toJson(), expand: _expand);
          _responseModels.add(_response);
        }
      }

      final _movements = _responseModels
          .map((e) => SupplyMovement.fromRecordModel(e))
          .toList();

      _movements.map((x) async {
        //@SUPPLY_MOVEMENT: mutate clinic_supplies with the movement
        final _clinicInventoryApi = ClinicInventoryApi(clinic_id: x.clinic.id);
        //@SUPPLY_MOVEMENT: get the supplies of the clinic
        final _invItemsRequest = await _clinicInventoryApi
            .fetchClinicInventoryItems();

        //@SUPPLY_MOVEMENT: parse into list of clinicInventoryItems
        final _items =
            (_invItemsRequest as ApiDataResult<List<ClinicInventoryItem>>).data;

        //@SUPPLY_MOVEMENT: find the item that needs mutation
        ClinicInventoryItem? _item = _items.firstWhereOrNull(
          (i) => i.supply_item.id == x.supply_item.id,
        );

        //@SUPPLY_MOVEMENT: if the item is not found
        if (_item == null) {
          final _unfoundItem = ClinicInventoryItem(
            id: '',
            clinic_id: x.clinic.id,
            supply_item: x.supply_item,
            available_quantity: x.movement_quantity,
          );
          //@SUPPLY_MOVEMENT: create a new entry in the clinic__supplies collection with the movement amount
          await _clinicInventoryApi.addNewInventoryItems([_unfoundItem]);
        } else {
          //@SUPPLY_MOVEMENT: transform the item based on the movement
          final _transformedItem = SupplyMovementTransformer()
              .toClinicInventoryItem(x, _item);

          //@SUPPLY_MOVEMENT: add/update item in the collection
          await _clinicInventoryApi.updateInventoryItemAvailableQuantity(
            inventoryItem: _transformedItem,
          );
        }
        //@SUPPLY_MOVEMENT: mutate bookkeeping with the movement
        final _bookkeepingTransformer = BookkeepingTransformer(
          item_id: x.id,
          collection_id: collection,
        );
        if (x.visit_id == null || x.visit_id == '') {
          final _bk = _bookkeepingTransformer.fromManualSupplyMovement(x);
          await BookkeepingApi().addBookkeepingItem(_bk);
        } else {
          if (x.movement_type == 'out_to_in') {
            final _bk = _bookkeepingTransformer.fromVisitRemoveSupplyMovement(
              x,
            );
            await BookkeepingApi().addBookkeepingItem(_bk);
          } else if (x.movement_type == 'in_to_out') {
            final _bk = _bookkeepingTransformer.fromVisitAddSupplyMovement(x);
            await BookkeepingApi().addBookkeepingItem(_bk);
          }
        }
      }).toList();

      return ApiDataResult<List<SupplyMovement>>(data: _movements);
    } on ClientException catch (e) {
      return ApiErrorResult<List<SupplyMovement>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<SupplyMovement>>> fetchSupplyMovements({
    required DateTime from,
    required DateTime to,
  }) async {
    final _fromFormatted = DateFormat('yyyy-MM-dd', 'en').format(from);
    final _toFormatted = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(to.copyWith(day: to.day + 1));

    try {
      final _response = await PocketbaseHelper.pbData
          .collection(collection)
          .getFullList(
            expand: _expand,
            filter:
                "created >= '$_fromFormatted' && created <= '$_toFormatted'",
            sort: '-created',
          );

      // prettyPrint(_response);

      final _movements = _response
          .map((e) => SupplyMovement.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<SupplyMovement>>(data: _movements);
    } on ClientException catch (e) {
      return ApiErrorResult<List<SupplyMovement>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
