import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/patient_progress_note.dart';
import 'package:pocketbase/pocketbase.dart';

@PbData()
class ProgressNotesApi {
  final String patient_id;
  final String doc_id;

  ProgressNotesApi({
    required this.patient_id,
    required this.doc_id,
  });

  static const String collection = 'patient__progress__notes';

  Future<ApiResult<PatientProgressNote>> createProgressNote(
    PatientProgressNote note,
  ) async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .create(
            body: note.toJson(),
          );

      final _note = PatientProgressNote.fromJson(_result.toJson());

      return ApiDataResult<PatientProgressNote>(data: _note);
    } on ClientException catch (e) {
      return ApiErrorResult<PatientProgressNote>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<PatientProgressNote>>> fetchPaginatedProgressNotes({
    required int page,
    int perPage = 10,
  }) async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .getList(
            page: page,
            filter: "patient_id = '$patient_id' && doc_id = '$doc_id'",
            sort: '-visit_date, -time_of_note',
          );

      final _notes = _result.items
          .map((e) => PatientProgressNote.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<PatientProgressNote>>(data: _notes);
    } on ClientException catch (e) {
      return ApiErrorResult<List<PatientProgressNote>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<bool> deleteProgressNote(String id) async {
    try {
      await PocketbaseHelper().pbData.collection(collection).delete(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResult<PatientProgressNote>> updateProgressNote(
    String id,
    Map<String, dynamic> update,
  ) async {
    try {
      final _result = await PocketbaseHelper().pbData
          .collection(collection)
          .update(
            id,
            body: update,
          );

      final _note = PatientProgressNote.fromJson(_result.toJson());

      return ApiDataResult<PatientProgressNote>(data: _note);
    } on ClientException catch (e) {
      return ApiErrorResult<PatientProgressNote>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
