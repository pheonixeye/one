import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/pc_form.dart';
import 'package:one/models/pc_form_field.dart';

class FormsApi {
  const FormsApi();

  final String collection = 'forms';

  Future<void> createPcForm(PcForm form) async {
    await PocketbaseHelper.pbBase
        .collection(collection)
        .create(body: form.toJson());
  }

  Future<void> deletePcForm(String id) async {
    await PocketbaseHelper.pbBase.collection(collection).delete(id);
  }

  Future<ApiResult<List<PcForm>>> fetchDoctorForms() async {
    try {
      final _result = await PocketbaseHelper.pbBase
          .collection(collection)
          .getFullList();

      final _forms = _result.map((e) => PcForm.fromJson(e.toJson())).toList();

      return ApiDataResult<List<PcForm>>(data: _forms);
    } on ClientException catch (e) {
      return ApiErrorResult<List<PcForm>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> updatePcForm(PcForm form) async {
    await PocketbaseHelper.pbBase
        .collection(collection)
        .update(form.id, body: form.toJson());
  }

  Future<void> addNewFieldToForm(PcForm form, PcFormField newField) async {
    await PocketbaseHelper.pbBase
        .collection(collection)
        .update(
          form.id,
          body: {
            'form_fields': [
              ...form.form_fields.map((e) => e.toJson()),
              newField.toJson(),
            ],
          },
        );
  }

  Future<void> updateFieldValue(PcForm form, PcFormField toUpdate) async {
    final _newList = form.form_fields
      ..removeWhere((f) => f.id == toUpdate.id)
      ..add(toUpdate);
    await PocketbaseHelper.pbBase
        .collection(collection)
        .update(
          form.id,
          body: {
            'form_fields': [..._newList.map((e) => e.toJson())],
          },
        );
  }

  Future<void> removeFieldFromForm(PcForm form, PcFormField toRemove) async {
    final _newList = form.form_fields..removeWhere((f) => f.id == toRemove.id);
    await PocketbaseHelper.pbBase
        .collection(collection)
        .update(
          form.id,
          body: {
            'form_fields': [..._newList.map((e) => e.toJson())],
          },
        );
  }
}
