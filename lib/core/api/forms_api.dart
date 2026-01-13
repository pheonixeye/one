import 'package:one/annotations/pb_annotations.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/pk_form.dart';
import 'package:one/models/pk_field.dart';

@PbData()
class FormsApi {
  const FormsApi({
    required this.doc_id,
  });
  final String doc_id;

  final String forms_collection = 'forms';
  final String fields_collection = 'forms__fields';

  static const _expandList = ['fields'];

  static final _expand = _expandList.join(',');

  Future<void> createPcForm(PkForm form) async {
    await PocketbaseHelper.pbData
        .collection(forms_collection)
        .create(body: form.toJson());
  }

  Future<void> deletePcForm(String id) async {
    await PocketbaseHelper.pbData.collection(forms_collection).delete(id);
  }

  Future<ApiResult<List<PkForm>>> fetchDoctorForms() async {
    try {
      final _result = await PocketbaseHelper.pbData
          .collection(forms_collection)
          .getFullList(
            filter: "doc_id = '$doc_id'",
            expand: _expand,
          );

      final _forms = _result.map((e) => PkForm.fromRecordModel(e)).toList();

      return ApiDataResult<List<PkForm>>(data: _forms);
    } on ClientException catch (e) {
      return ApiErrorResult<List<PkForm>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> updatePcForm(PkForm form) async {
    await PocketbaseHelper.pbData
        .collection(forms_collection)
        .update(form.id, body: form.toJson());
  }

  Future<void> addNewFieldToForm(PkField newField) async {
    final _fieldAddRequest = await PocketbaseHelper.pbData
        .collection(fields_collection)
        .create(
          body: {
            ...newField.toJson(),
          },
        );

    final _field = PkField.fromJson(_fieldAddRequest.toJson());

    await PocketbaseHelper.pbData
        .collection(forms_collection)
        .update(
          _field.form_id,
          body: {
            'fields+': _field.id,
          },
        );
  }

  Future<void> updateFieldValue(PkField toUpdate) async {
    await PocketbaseHelper.pbData
        .collection(fields_collection)
        .update(
          toUpdate.id,
          body: {
            ...toUpdate.toJson(),
          },
        );
  }

  Future<void> removeFieldFromForm(PkField toRemove) async {
    await PocketbaseHelper.pbData
        .collection(fields_collection)
        .delete(toRemove.id);

    await PocketbaseHelper.pbData
        .collection(forms_collection)
        .update(
          toRemove.form_id,
          body: {
            'fields-': toRemove.id,
          },
        );
  }
}
