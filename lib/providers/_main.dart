import 'package:one/core/api/assistant_accounts_api.dart';
import 'package:one/core/api/blob_api.dart';
import 'package:one/core/api/contracts_api.dart';
import 'package:one/core/api/s3_patient_documents_api.dart';
import 'package:one/core/api/specialities_api.dart';
import 'package:one/models/doctor_items/doctor_doument_type.dart';
import 'package:one/providers/px_assistant_accounts.dart';
import 'package:one/providers/px_blobs.dart';
import 'package:one/providers/px_contracts.dart';
import 'package:one/providers/px_s3_documents.dart';
import 'package:one/providers/px_s3_patient_documents.dart';
import 'package:one/providers/px_speciality.dart';
import 'package:one/core/api/auth/api_auth.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/clinics_api.dart';
import 'package:one/core/api/constants_api.dart';
import 'package:one/core/api/doctor_api.dart';
import 'package:one/core/api/doctor_profile_items_api.dart';
import 'package:one/core/api/doctor_subscription_info_api.dart';
import 'package:one/core/api/forms_api.dart';
import 'package:one/core/api/patients_api.dart';
import 'package:one/core/api/supply_movement_api.dart';
import 'package:one/core/api/visits_api.dart';
import 'package:one/models/doctor_items/doctor_drug_item.dart';
import 'package:one/models/doctor_items/doctor_lab_item.dart';
import 'package:one/models/doctor_items/doctor_procedure_item.dart';
import 'package:one/models/doctor_items/doctor_rad_item.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_bookkeeping.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_doc_subscription_info.dart';
import 'package:one/providers/px_doctor.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_forms.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_patients.dart';
import 'package:one/providers/px_supply_movements.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/router/router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider.value(
    value: AppRouter.router.routeInformationProvider,
  ),
  ChangeNotifierProvider(
    create: (context) => PxLocale(),
  ),

  ChangeNotifierProvider(
    create: (context) => PxSpec(
      api: const SpecialitiesApi(),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => PxAppConstants(
      api: const ConstantsApi(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxAuth(
      api: const AuthApi(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxS3Documents(
      context: context,
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxS3PatientDocuments(
      api: const S3PatientDocumentApi(),
      context: context,
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxBlobs(
      api: BlobApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxDoctor(
      context: context,
      api: DoctorApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxAssistantAccounts(
      api: AssistantAccountsApi(
        org_id: '${context.read<PxAuth>().organization?.id}',
      ),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxDocSubscriptionInfo(
      api: DoctorSubscriptionInfoApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),

  //profile items providers
  ChangeNotifierProvider(
    // key: ValueKey(ProfileSetupItem.drugs),
    create: (context) => PxDoctorProfileItems<DoctorDrugItem>(
      api: DoctorProfileItemsApi<DoctorDrugItem>(
        item: ProfileSetupItem.drugs,
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    // key: ValueKey(ProfileSetupItem.labs),
    create: (context) => PxDoctorProfileItems<DoctorLabItem>(
      api: DoctorProfileItemsApi<DoctorLabItem>(
        item: ProfileSetupItem.labs,
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    // key: ValueKey(ProfileSetupItem.rads),
    create: (context) => PxDoctorProfileItems<DoctorRadItem>(
      api: DoctorProfileItemsApi<DoctorRadItem>(
        item: ProfileSetupItem.rads,
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    // key: ValueKey(ProfileSetupItem.supplies),
    create: (context) => PxDoctorProfileItems<DoctorSupplyItem>(
      api: DoctorProfileItemsApi<DoctorSupplyItem>(
        item: ProfileSetupItem.supplies,
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    // key: ValueKey(ProfileSetupItem.procedures),
    create: (context) => PxDoctorProfileItems<DoctorProcedureItem>(
      api: DoctorProfileItemsApi<DoctorProcedureItem>(
        item: ProfileSetupItem.procedures,
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    // key: ValueKey(ProfileSetupItem.documents),
    create: (context) => PxDoctorProfileItems<DoctorDocumentTypeItem>(
      api: DoctorProfileItemsApi<DoctorDocumentTypeItem>(
        item: ProfileSetupItem.documents,
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  //profile items providers##
  ChangeNotifierProvider(
    create: (context) => PxForms(
      api: FormsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxClinics(
      context: context,
      api: ClinicsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxContracts(
      api: const ContractsApi(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxPatients(
      context: context,
      api: const PatientsApi(),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => PxVisits(
      api: VisitsApi(
        added_by: '${context.read<PxAuth>().user?.name}',
      ),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => PxSupplyMovements(
      api: SupplyMovementApi(
        added_by: '${context.read<PxAuth>().user?.name}',
      ),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => PxBookkeeping(
      api: BookkeepingApi(),
    ),
  ),
];
