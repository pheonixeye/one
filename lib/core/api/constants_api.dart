// import 'dart:convert';

// import 'package:hive_ce/hive.dart';
import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/app_constants/_app_constants.dart';
import 'package:one/models/app_constants/app_permission.dart';
import 'package:one/models/app_constants/patient_progress_status.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/subscriptions/plan.dart';

@PbBase()
class ConstantsApi {
  const ConstantsApi();
  // static final _n = DateTime.now();
  static const _perPage = 200;

  static const String account_types = 'account_types';
  static const String visit_status = 'visit_status';
  static const String visit_type = 'visit_type';
  static const String subscription_plan = 'plans';
  static const String patient_progress_status = 'patient_progress_status';
  static const String app_permissions = 'app_permissions';
  // static const String document_type = 'document_type';

  static const String collection = 'constants';
  static String collectionSaveDate = 'constants_save_date';

  Future<AppConstants> fetchConstants() async {
    AppConstants? _constants;

    late final List<AccountType> accountTypes;
    late final List<VisitStatus> visitStatus;
    late final List<VisitType> visitType;
    late final List<Plan> subscriptionPlan;
    late final List<PatientProgressStatus> patientProgressStatus;
    late final List<AppPermission> appPermission;
    // late final List<DocumentType> documentType;

    final _accountTypesRequest = PocketbaseHelper.pbBase
        .collection(account_types)
        .getList(perPage: _perPage);

    final _visitStatusRequest = PocketbaseHelper.pbBase
        .collection(visit_status)
        .getList(perPage: _perPage);

    final _visitTypeRequest = PocketbaseHelper.pbBase
        .collection(visit_type)
        .getList(perPage: _perPage);

    final _subscriptionPlanRequest = PocketbaseHelper.pbBase
        .collection(subscription_plan)
        .getList(perPage: _perPage);

    final _patientProgressStatusRequest = PocketbaseHelper.pbBase
        .collection(patient_progress_status)
        .getList(perPage: _perPage);

    final _appPermissionRequest = PocketbaseHelper.pbBase
        .collection(app_permissions)
        .getList(perPage: _perPage);

    final _result = await Future.wait([
      _accountTypesRequest,
      _visitStatusRequest,
      _visitTypeRequest,
      _subscriptionPlanRequest,
      _patientProgressStatusRequest,
      _appPermissionRequest,
      // _documentTypeRequest,
    ]);

    accountTypes = _result[0].items
        .map((e) => AccountType.fromJson(e.toJson()))
        .toList();

    visitStatus = _result[1].items
        .map((e) => VisitStatus.fromJson(e.toJson()))
        .toList();

    visitType = _result[2].items
        .map((e) => VisitType.fromJson(e.toJson()))
        .toList();

    subscriptionPlan = _result[3].items
        .map((e) => Plan.fromJson(e.toJson()))
        .toList();

    patientProgressStatus = _result[4].items
        .map((e) => PatientProgressStatus.fromJson(e.toJson()))
        .toList();

    appPermission = _result[5].items
        .map((e) => AppPermission.fromJson(e.toJson()))
        .toList();

    _constants = AppConstants(
      accountTypes: accountTypes,
      visitStatus: visitStatus,
      visitType: visitType,
      subscriptionPlan: subscriptionPlan,
      patientProgressStatus: patientProgressStatus,
      appPermission: appPermission,
    );

    return _constants;
  }
}
