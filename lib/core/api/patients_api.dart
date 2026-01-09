import 'package:pocketbase/pocketbase.dart';
// import 'package:one/core/api/cache/api_caching_service.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/patient.dart';

class PatientsApi {
  const PatientsApi();

  final String _collection = 'patients';

  Future<ApiResult> fetchPatients({
    required int page,
    required int perPage,
  }) async {
    try {
      final _response = await PocketbaseHelper.pbData
          .collection(_collection)
          .getList(page: page, perPage: perPage, sort: '-created');

      final patients = _response.items
          .map((e) => Patient.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> createPatientProfile(Patient patient) async {
    await PocketbaseHelper.pbData
        .collection(_collection)
        .create(body: patient.toJson());
  }

  Future<ApiResult> searchPatientByPhone({required String query}) async {
    try {
      final _response = await PocketbaseHelper.pbData
          .collection(_collection)
          .getList(filter: "phone = '$query'");

      final patients = _response.items
          .map((e) => Patient.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult> searchPatientByName({
    required String query,
    required int page,
    required int perPage,
  }) async {
    try {
      final _response = await PocketbaseHelper.pbData
          .collection(_collection)
          .getList(
            filter: "name ?~ '$query'",
            sort: '-created',
            page: page,
            perPage: perPage,
          );
      final patients = _response.items
          .map((e) => Patient.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<Patient>>(data: patients);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> editPatientBaseData(Patient patient) async {
    await PocketbaseHelper.pbData
        .collection(_collection)
        .update(patient.id, body: patient.toJson());
  }

  static Future<Patient> getPatientById(String patientId) async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection('patients')
          .getOne(patientId);

      final _patient = Patient.fromJson(_result.toJson());

      return _patient;
    } catch (e) {
      rethrow;
    }
  }
}
