import 'package:one/core/api/_api_result.dart';

abstract class PiApi<T> {
  Future<ApiResult<List<T>>> fetchDoctorItems();

  Future<void> createItem(T item);

  Future<void> updateItem(String id, T update);

  Future<void> deleteItem(String id);
}
