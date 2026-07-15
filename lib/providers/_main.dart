import 'package:flutter/material.dart' show ValueKey;
import 'package:one/core/api/assistant_accounts_api.dart';
import 'package:one/core/api/blob_api.dart';
import 'package:one/core/api/contracts_api.dart';
import 'package:one/core/api/pb_notifications_api.dart';
import 'package:one/core/api/profile_items_api/pi_document_types_api.dart';
import 'package:one/core/api/profile_items_api/pi_drugs_api.dart';
import 'package:one/core/api/profile_items_api/pi_labs_api.dart';
import 'package:one/core/api/profile_items_api/pi_procedures_api.dart';
import 'package:one/core/api/profile_items_api/pi_rads_api.dart';
import 'package:one/core/api/profile_items_api/pi_referrals_api.dart';
import 'package:one/core/api/profile_items_api/pi_supply_items_api.dart';
import 'package:one/core/api/reciept_info_api.dart';
import 'package:one/core/api/s3_patient_documents_api.dart';
import 'package:one/core/api/specialities_api.dart';
import 'package:one/providers/px_assistant_accounts.dart';
import 'package:one/providers/px_blobs.dart';
import 'package:one/providers/px_contracts.dart';
import 'package:one/providers/px_firebase_notifications.dart';
import 'package:one/providers/px_pb_notifications.dart';
import 'package:one/providers/px_profile_items/px_pi_documents.dart';
import 'package:one/providers/px_profile_items/px_pi_drugs.dart';
import 'package:one/providers/px_profile_items/px_pi_labs.dart';
import 'package:one/providers/px_profile_items/px_pi_procedures.dart';
import 'package:one/providers/px_profile_items/px_pi_rads.dart';
import 'package:one/providers/px_profile_items/px_pi_referrals.dart';
import 'package:one/providers/px_profile_items/px_pi_supplies.dart';
import 'package:one/providers/px_reciept_info.dart';
import 'package:one/providers/px_s3_documents.dart';
import 'package:one/providers/px_s3_patient_documents.dart';
import 'package:one/providers/px_speciality.dart';
import 'package:one/core/api/auth/api_auth.dart';
import 'package:one/core/api/bookkeeping_api.dart';
import 'package:one/core/api/clinics_api.dart';
import 'package:one/core/api/constants_api.dart';
import 'package:one/core/api/doctor_api.dart';
import 'package:one/core/api/subscription_api.dart';
import 'package:one/core/api/forms_api.dart';
import 'package:one/core/api/patients_api.dart';
import 'package:one/core/api/supply_movement_api.dart';
import 'package:one/core/api/visits_api.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';
import 'package:one/providers/px_app_constants.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_bookkeeping.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_subscription.dart';
import 'package:one/providers/px_doctor.dart';
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
    create: (context) => PxFirebaseNotifications(),
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
      api: AuthApi(),
      context: context,
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxSubscription(
      api: SubscriptionApi(
        org_id: '${context.read<PxAuth>().organization?.id}',
      ),
      context: context,
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
        org_id: '${context.read<PxAuth>().organization?.id}',
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

  ///!![NEW] profile items providers
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.drugs),
    create: (context) => PxPiDrugs(
      api: PiDrugsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.labs),
    create: (context) => PxPiLabs(
      api: PiLabsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.rads),
    create: (context) => PxPiRads(
      api: PiRadsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.procedures),
    create: (context) => PxPiProcedures(
      api: PiProceduresApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.supplies),
    create: (context) => PxPiSupplies(
      api: PiSupplyItemsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.documents),
    create: (context) => PxPiDocuments(
      api: PiDocumentTypesApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.referrals),
    create: (context) => PxPiReferrals(
      api: PiReferralsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),

  //profile items providers##
  ChangeNotifierProvider(
    create: (context) => PxForms(
      context: context,
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
      api: ContractsApi(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxPatients(
      context: context,
      api: PatientsApi(),
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
    create: (context) => PxRecieptInfo(
      api: RecieptInfoApi(),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => PxBookkeeping(
      api: BookkeepingApi(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxPbNotifications(
      api: PbNotificationsApi(),
    ),
  ),
];
