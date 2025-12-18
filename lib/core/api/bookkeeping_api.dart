import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/models/bookkeeping/bookkeeping_item_dto.dart';

class BookkeepingApi {
  BookkeepingApi({this.visit_id});
  final String? visit_id;

  late final String collection = 'bookkeeping';
  //TODO: CHANGE CONSTANT
  static const _batch = 5000;

  Future<void> addBookkeepingItem(BookkeepingItemDto item) async {
    await PocketbaseHelper.pb
        .collection(collection)
        .create(body: item.toJson());
  }

  final _expandList = ['added_by_id', 'updated_by_id'];

  late final _expand = _expandList.join(',');

  Future<ApiResult<List<BookkeepingItem>>> fetchDetailedItems({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final formattedFrom = DateFormat('yyyy-MM-dd', 'en').format(from);
      final formattedTo = DateFormat(
        'yyyy-MM-dd',
        'en',
      ).format(to.copyWith(day: to.day + 1));
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFullList(
            filter: "created >= '$formattedFrom' && created <= '$formattedTo'",
            sort: '-created',
            expand: _expand,
            batch: _batch,
          );

      final _items = _response
          .map((e) => BookkeepingItem.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<BookkeepingItem>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<BookkeepingItem>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<BookkeepingItemDto>>> fetchItems({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final formattedFrom = DateFormat('yyyy-MM-dd', 'en').format(from);
      final formattedTo = DateFormat(
        'yyyy-MM-dd',
        'en',
      ).format(to.copyWith(day: to.day + 1));
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFullList(
            filter: 'created >= $formattedFrom && created <= $formattedTo',
            sort: 'created-',
          );

      final _items = _response
          .map((e) => BookkeepingItemDto.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<BookkeepingItemDto>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<BookkeepingItemDto>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<BookkeepingItemDto>>>
  fetchBookkeepingOfOneVisit() async {
    try {
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFullList(
            filter: "item_id = '$visit_id' && amount != 0",
            sort: 'created',
          );

      final _items = _response
          .map((e) => BookkeepingItemDto.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<BookkeepingItemDto>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<BookkeepingItemDto>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<BookkeepingItemDto>>>
  fetchNonZeroBookkeepingOfDuration({
    required DateTime from,
    required DateTime to,
  }) async {
    final formattedFrom = DateFormat('yyyy-MM-dd', 'en').format(from);
    final formattedTo = DateFormat('yyyy-MM-dd', 'en').format(to);
    try {
      final _response = await PocketbaseHelper.pb
          .collection(collection)
          .getFullList(
            filter:
                "created >= '$formattedFrom' && created <= '$formattedTo' && amount != 0",
            sort: 'created',
            batch: _batch,
          );

      final _items = _response
          .map((e) => BookkeepingItemDto.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<BookkeepingItemDto>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<BookkeepingItemDto>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
