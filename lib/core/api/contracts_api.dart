import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/contract.dart';
import 'package:pocketbase/pocketbase.dart';

@PbData()
class ContractsApi {
  const ContractsApi();

  static const String collection = 'contracts';

  Future<void> addNewContract(Contract contract) async {
    await PocketbaseHelper.pbData
        .collection(collection)
        .create(
          body: contract.toJson(),
        );
  }

  Future<ApiResult<List<Contract>>> fetchAllContracts() async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(collection)
          .getFullList();

      final _contracts = _result
          .map((e) => Contract.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<Contract>>(data: _contracts);
    } on ClientException catch (e) {
      return ApiErrorResult<List<Contract>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> updateContract(String contract_id, Contract updated) async {
    await PocketbaseHelper.pbData
        .collection(collection)
        .update(
          contract_id,
          body: {
            ...updated.toJson(),
          },
        );
  }
}
