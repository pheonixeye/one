enum BookkeepingName {
  //TODO: Add to app constants
  operation_unknown,
  //visit
  visit_create,
  visit_no_update,
  visit_add_discount,
  visit_remove_discount,
  //visit_attendance
  visit_attendance_update_attended,
  visit_attendance_update_not_attended,
  //visit_type
  visit_type_update,
  visit_type_update_consultation,
  visit_type_update_followup,
  visit_type_update_procedure,
  //visit_procedures
  visit_procedure_add,
  visit_procedure_remove,
  //visit_supplies
  visit_supplies_add,
  visit_supplies_remove,
  visit_supplies_no_update,
  //supplies
  supplies_movement_add_manual,
  supplies_movement_remove_manual,
  supplies_movement_no_update_manual;

  factory BookkeepingName.fromString(String value) {
    try {
      return BookkeepingName.values
          .firstWhere((e) => value == e.name.split('.').last);
    } catch (e) {
      return operation_unknown;
    }
  }
}

extension ToArabic on BookkeepingName {
  String ar() {
    return switch (this) {
      BookkeepingName.operation_unknown => 'عملية غير معروفة',
      BookkeepingName.visit_create => 'الزيارات - اضافة',
      BookkeepingName.visit_no_update => "الزيارات - بدون تعديل",
      BookkeepingName.visit_add_discount => "الزيارات - اضافة خصم للزيارة",
      BookkeepingName.visit_remove_discount =>
        "الزيارات - ازالة خصم من الزيارة",
      BookkeepingName.visit_attendance_update_attended =>
        "الزيارات - تم حضور الزيارة",
      BookkeepingName.visit_attendance_update_not_attended =>
        "الزيارات - تم الغاء حضور الزيارة",
      BookkeepingName.visit_type_update => "نوع الزيارة - تعديل",
      BookkeepingName.visit_type_update_consultation =>
        "نوع الزيارة - تعديل الي كشف",
      BookkeepingName.visit_type_update_followup =>
        "نوع الزيارة - تعديل الي استشارة",
      BookkeepingName.visit_type_update_procedure =>
        "نوع الزيارة - تعديل الي اجراء طبي",
      BookkeepingName.visit_procedure_add =>
        "الزيارات - اضافة اجراء طبي للزيارة",
      BookkeepingName.visit_procedure_remove =>
        "الزيارات - ازالة اجراء طبي من الزيارة",
      BookkeepingName.visit_supplies_add => "الزيارات - اضافة مستلزم للزيارة",
      BookkeepingName.visit_supplies_remove =>
        "الزيارات - ازالة مستلزم من الزيارة",
      BookkeepingName.visit_supplies_no_update =>
        "الزيارات - لا تعديل علي مستلومات الزيارة",
      BookkeepingName.supplies_movement_add_manual =>
        "حركة المستلزمات - اضافة حركة مستلزمات يدويا",
      BookkeepingName.supplies_movement_remove_manual =>
        "حركة المستلومات - ازالة حركة مستلزمات يدويا",
      BookkeepingName.supplies_movement_no_update_manual =>
        "حركة المستلزمات - لا تعديل",
    };
  }
}
