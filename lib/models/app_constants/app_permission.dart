import 'package:equatable/equatable.dart';

class AppPermission extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;

  const AppPermission({
    required this.id,
    required this.name_en,
    required this.name_ar,
  });

  AppPermission copyWith({
    String? id,
    String? name_en,
    String? name_ar,
  }) {
    return AppPermission(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
    };
  }

  factory AppPermission.fromJson(Map<String, dynamic> map) {
    return AppPermission(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name_en, name_ar];
}

enum PermissionEnum {
  SuperAdmin,
  Admin,
  User,
  User_Patient_AddNew, //done
  User_Patient_EditInfo, //done
  User_Patient_AddNewVisit, //done
  User_Patient_PreviousVisits, //done
  User_Patient_InfoCard, //done
  User_Patient_Call, //done
  User_Patient_Whatsapp, //done
  User_Patient_Email, //done
  User_Patient_Forms, //done
  User_Patient_AddDocument,
  User_Patient_ViewDocuments,
  User_Visits_Read, //done
  User_Visits_PrintReciept,
  User_Visits_PrintExcel,
  User_Bookkeeping_Read, //done
  User_Bookkeeping_Add, //done
  User_AccountSettings_Read, //done
  User_AccountSettings_Add, //done
  User_AccountSettings_Modify, //done
  User_AccountSettings_Delete, //done
  User_TodayVisits_Read, //done
  User_TodayVisits_Modify_Entry_Number, //done
  User_TodayVisits_Modify_Attendance, //done
  User_TodayVisits_Modify_Visit_Type, //done
  User_TodayVisits_Modify_Visit_Progress, //done
  User_Clinics_Read, //done
  User_Clinics_Modify, //done
  User_Clinics_Add, //done
  User_Clinics_Activity, //done
  User_Clinics_Schedule, //done
  User_Clinics_Prescription, //done
  User_Clinics_Store, //done
  User_Clinics_Delete, //done
  User_SupplyMovements_Read, //done
  User_SupplyMovement_Add, //done
  User_Subscription_Read,
  User_Subscription_Modify,
  // User_AssistantAccounts_Read,
  // User_AssistantAccounts_Modify,
  // User_AssistantAccounts_Delete,
  User_Forms_Read, //done
  User_Forms_Add, //done
  User_Forms_Modify, //done
  User_Forms_Delete, //done
  //todo: add wa persmissions && discount permissions && reschedule visit
  User_TodayVisits_Add_Discount, //done
  User_TodayVisits_Remove_Discount, //done
  User_Whatsapp_Login, //done
  User_Whatsapp_Fetch_Devices, //done
  User_Whatsapp_Logout, //done
  User_TodayVisits_Reschedule_Visit; //done

  factory PermissionEnum.fromString(String value) {
    return PermissionEnum.values.firstWhere((x) => x.name == value);
  }
}

class PermissionWithPermission extends Equatable {
  final AppPermission permission;
  final bool isAllowed;

  const PermissionWithPermission({
    required this.permission,
    required this.isAllowed,
  });

  @override
  List<Object> get props => [
        permission,
        isAllowed,
      ];
}
