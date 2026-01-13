import 'package:one/annotations/pb_annotations.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/patient_form_field_data.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/models/pk_form.dart';
import 'package:collection/collection.dart';

@PbData()
class PatientFormsApi {
  final String patient_id;
  final String doc_id;

  PatientFormsApi({
    required this.patient_id,
    required this.doc_id,
  });

  late final String collection = 'patient__formdata';

  Future<ApiResult<List<PatientFormItem>>> fetchPatientForms() async {
    try {
      final _response = await PocketbaseHelper.pbData
          .collection(collection)
          .getList(
            filter: "patient_id = '$patient_id' && doc_id = '$doc_id'",
            sort: '-created',
          );

      final _patientFormData = _response.items
          .map((e) => PatientFormItem.fromJson(e.toJson()))
          .toList();

      // dprint(_patientFormData);

      return ApiDataResult<List<PatientFormItem>>(data: _patientFormData);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> attachFormToPatient(PatientFormItem formItem) async {
    await PocketbaseHelper.pbData
        .collection(collection)
        .create(body: formItem.toJson());
  }

  Future<void> detachFormFromPatient(PatientFormItem formItem) async {
    await PocketbaseHelper.pbData.collection(collection).delete(formItem.id);
  }

  Future<void> updatePatientFormFieldData(
    PatientFormItem formItem,
    PatientFormFieldData formData,
  ) async {
    final _newData = formItem.form_data
      ..removeWhere((e) => e.id == formData.id)
      ..add(formData);

    await PocketbaseHelper.pbData
        .collection(collection)
        .update(
          formItem.id,
          body: {'form_data': _newData.map((e) => e.toJson()).toList()},
        );
  }

  Future<void> checkIfFormIsUpdated(
    PatientFormItem formItem,
    PkForm form,
  ) async {
    final _bluePrintIds = form.fields.map((e) => e.id).toList();
    final _dataIds = formItem.form_data.map((e) => e.id).toList();
    // print(_bluePrintIds);
    // print(_dataIds);
    if (DeepCollectionEquality.unordered().equals(_bluePrintIds, _dataIds)) {
      return;
    }
    late final List<PatientFormFieldData> _newData;

    if (_bluePrintIds.length > _dataIds.length) {
      final _newField = form.fields.firstWhere(
        (e) => !_dataIds.contains(e.id),
      );
      final _newFormData = PatientFormFieldData(
        id: _newField.id,
        field_name: _newField.field_name,
        field_value: '',
      );
      _newData = formItem.form_data..add(_newFormData);
    } else {
      _dataIds.map((id) {
        if (_bluePrintIds.contains(id)) {
          return;
        } else {
          _newData = formItem.form_data..removeWhere((e) => e.id == id);
        }
      }).toList();
    }
    await PocketbaseHelper.pbData
        .collection(collection)
        .update(
          formItem.id,
          body: {'form_data': _newData.map((e) => e.toJson()).toList()},
        );
  }
}
