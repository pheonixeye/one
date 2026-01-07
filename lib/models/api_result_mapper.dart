import 'package:one/annotations/unused.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/patient_form_item.dart';
import 'package:one/models/pc_form.dart';

@Unused('//TODO')
//TODO
typedef PatientDataResult = ApiDataResult<List<Patient>>;

typedef FormDataResult = ApiDataResult<List<PcForm>>;

typedef PatientFormItemResult = ApiDataResult<List<PatientFormItem>>;
