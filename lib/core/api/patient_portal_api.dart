import 'package:intl/intl.dart';
import 'package:one/annotations/pb_annotations.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/constants/pocketbase_helper.dart';
import 'package:one/core/logic/bookkeeping_transformer.dart';
import 'package:one/errors/code_to_error.dart';
import 'package:one/models/app_constants/account_type.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/doctor_items/doctor_referral_item.dart';
import 'package:one/models/organization.dart';
import 'package:one/models/patient.dart';
import 'package:one/models/patient_document/patient_document.dart';
import 'package:one/models/patients_portal/portal_query.dart';
import 'package:one/models/visit_data/visit_data_dto.dart';
import 'package:one/models/visits/visit.dart';
import 'package:pocketbase/pocketbase.dart';

class PatientPortalApi {
  const PatientPortalApi({
    required this.query,
  });

  final PortalQuery query;

  static const String account_types_collection = 'account_types';

  @PbBase()
  Future<ApiResult<List<AccountType>>> fetchAccountTypes() async {
    try {
      final _accountTypesRequest = await PocketbaseHelper.pbBase
          .collection(account_types_collection)
          .getList(perPage: 10);

      final _data = _accountTypesRequest.items
          .map((e) => AccountType.fromJson(e.toJson()))
          .toList();

      return ApiDataResult<List<AccountType>>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbBase()
  Future<ApiResult<OrganizationExpanded>> fetchOrganization() async {
    if (query.org_id == null) {
      return ApiErrorResult<OrganizationExpanded>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: AppErrorCode.clientException.name,
      );
    }
    try {
      final _result = await PocketbaseHelper.pbBase
          .collection('organizations')
          .getOne(
            query.org_id!,
            expand: 'members',
          );
      final _data = OrganizationExpanded.fromRecordModel(_result);

      return ApiDataResult<OrganizationExpanded>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<Patient>> fetchPatient() async {
    if (query.patient_id == null) {
      return ApiErrorResult<Patient>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: AppErrorCode.clientException.name,
      );
    }
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('patients')
          .getOne(query.patient_id!);
      final _data = Patient.fromJson(_result.toJson());

      return ApiDataResult<Patient>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<Patient>> addNewPatientOrFetchPatientIfAlreadyExists(
    Patient patient,
  ) async {
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('patients')
          .create(
            body: patient.toJson(),
          );

      final _data = Patient.fromJson(_result.toJson());

      return ApiDataResult<Patient>(data: _data);
    } on ClientException catch (_) {
      try {
        final _result = await PocketbaseHelper.pbPortal
            .collection('patients')
            .getFirstListItem("phone = '${patient.phone}'");

        final _data = Patient.fromJson(_result.toJson());

        return ApiDataResult<Patient>(data: _data);
      } on ClientException catch (e) {
        return ApiErrorResult(
          errorCode: AppErrorCode.clientException.code,
          originalErrorMessage: e.toString(),
        );
      }
    }
  }

  @PbPortal()
  Future<ApiResult<Patient>> fetchPatientById(String patient_id) async {
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('patients')
          .getOne(patient_id);
      final _data = Patient.fromJson(_result.toJson());

      return ApiDataResult<Patient>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  static const _visitsExpand = 'doc_id, clinic_id, patient_id, referral_id';

  @PbPortal()
  Future<ApiResult<List<VisitExpanded>>> fetchVisitsOfOnePatient() async {
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('visits')
          .getFullList(
            filter: 'patient_id = "${query.patient_id}"',
            expand: _visitsExpand,
            sort: '-created',
          );
      final _data = _result
          .map((e) => VisitExpanded.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<VisitExpanded>>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<List<Clinic>>> fetchDoctorClinics() async {
    late List<Clinic> _clinics;

    try {
      final _response = await PocketbaseHelper.pbPortal
          .collection('clinics')
          .getList(filter: "doc_id ~ '${query.doc_id}'");
      try {
        _clinics = _response.items
            .map((e) => Clinic.fromJson(e.toJson()))
            .toList();
      } catch (e) {
        // dprint('parsing Error => ${e.toString()}');
      }

      return ApiDataResult<List<Clinic>>(data: _clinics);
    } catch (e) {
      return ApiErrorResult<List<Clinic>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<List<VisitExpanded>>> fetctVisitsOfOneMonthOneClinic({
    required int month,
    required int year,
    required String clinic_id,
  }) async {
    final _month_date = DateTime(year, month, 1);
    final _month_plus_date = DateTime(year, month + 1, 1);

    final _formatted_month_date = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(_month_date);
    final _formatted_month_plus_date = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(_month_plus_date);

    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('visits')
          .getFullList(
            filter:
                "visit_date >= '$_formatted_month_date' && visit_date <= '$_formatted_month_plus_date' && clinic_id = '$clinic_id'",
            expand: _visitsExpand,
          );

      final _visits = _result.map((e) {
        return VisitExpanded.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<VisitExpanded>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<List<PatientDocumentWithDocumentType>>> fetchVisitDocuments({
    required String visit_id,
  }) async {
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('patient__documents')
          .getFullList(
            filter:
                'patient_id = "${query.patient_id}" && related_visit_id = "$visit_id"',
            expand: 'document_type_id',
            sort: '-created',
          );
      final _data = _result
          .map((e) => PatientDocumentWithDocumentType.fromRecordModel(e))
          .toList();

      return ApiDataResult<List<PatientDocumentWithDocumentType>>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<List<Clinic>>> fetchClinics() async {
    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('clinics')
          .getFullList(
            expand: 'doc_id',
            sort: '-created',
          );
      final _data = _result.map((e) => Clinic.fromJson(e.toJson())).toList();
      // prettyPrint(_data);
      return ApiDataResult<List<Clinic>>(data: _data);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  @PbPortal()
  Future<ApiResult<VisitExpanded>> addNewVisit(
    Visit visit,
  ) async {
    //TODO: error handling
    //create visit reference
    final _result = await PocketbaseHelper.pbPortal
        .collection('visits')
        .create(
          body: visit.toJson(),
          expand: _visitsExpand,
        );

    //create visit_data reference
    final _visitDataResult = await PocketbaseHelper.pbPortal
        .collection('visit__data')
        .create(
          body: VisitDataDto.initial(
            doc_id: visit.doc_id,
            visit_id: _result.id,
            patient_id: visit.patient_id,
            clinic_id: visit.clinic_id,
          ).toJson(),
        );

    //todo: parse result
    final _visit = VisitExpanded.fromRecordModel(_result);

    //todo: initialize transformer
    final _bk_transformer = BookkeepingTransformer(
      item_id: _visit.id,
      collection_id: 'visits',
      added_by: 'portal_booking', //TODO
    );

    //todo: initialize bk_item
    final _item = _bk_transformer.fromVisitCreate(
      _visit,
      _visitDataResult.id,
    );

    //todo: send bookkeeping request
    await addBookkeepingItem(_item);

    //todo: send inclinic notification => deferred to separate logic transformer

    return ApiDataResult(data: _visit);
  }

  @PbPortal()
  Future<ApiResult<DoctorReferralItem>> fetchOrCreatePortalBookingsReferral(
    String? doc_id,
  ) async {
    if (doc_id == null || doc_id.isEmpty) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: 'Doc_Id is Undefined.',
      );
    }

    try {
      final _result = await PocketbaseHelper.pbPortal
          .collection('referrals')
          .getFirstListItem(
            "name_en = '${DoctorReferralItem.onlineBooking(doc_id).name_en}' && doc_id = '$doc_id'",
          );
      final _referral = DoctorReferralItem.fromJson(
        _result.toJson(),
      );

      return ApiDataResult<DoctorReferralItem>(data: _referral);
    } catch (e) {
      try {
        final _result = await PocketbaseHelper.pbPortal
            .collection('referrals')
            .create(
              body: DoctorReferralItem.onlineBooking(doc_id).toJson(),
            );

        final _referral = DoctorReferralItem.fromJson(
          _result.toJson(),
        );

        return ApiDataResult<DoctorReferralItem>(data: _referral);
      } on ClientException catch (e) {
        return ApiErrorResult(
          errorCode: AppErrorCode.clientException.code,
          originalErrorMessage: e.toString(),
        );
      }
    }
  }

  @PbPortal()
  Future<void> addBookkeepingItem(BookkeepingItem item) async {
    await PocketbaseHelper.pbPortal
        .collection('bookkeeping')
        .create(body: item.toJson());
  }
}
