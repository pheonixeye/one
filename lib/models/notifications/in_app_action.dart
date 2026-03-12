enum InAppAction {
  add_new_visit(
    en_title: 'New Visit',
    ar_title: 'زيارة جديدة',
    toNotify: 'Doctor',
  ),
  add_procedure_to_visit(
    en_title: 'Procedure Added To Visit',
    ar_title: 'تم اضافة اجراء لزيارة',
    toNotify: 'Assistant',
  ),
  remove_procedure_from_visit(
    en_title: 'Procedure Removed From Visit',
    ar_title: 'تم ازالة اجراء من زيارة',
    toNotify: 'Assistant',
  ),
  add_discount_to_visit(
    en_title: 'Discount Added To Visit',
    ar_title: 'تم اضافة خصم للزيارة',
    toNotify: 'All',
  ),
  remove_discount_from_visit(
    en_title: 'Discount Removed From Visit',
    ar_title: 'تم ازالة خصم من الزيارة',
    toNotify: 'All',
  ),
  update_visit_status(
    en_title: 'Visit Status Updated',
    ar_title: 'تم تعديل حالة حضور الزيارة',
    toNotify: 'Doctor',
  ),
  update_visit_shift(
    en_title: 'Visit Shift Changed',
    ar_title: 'تم تعديل موعد الزيارة',
    toNotify: 'Doctor',
  ),
  update_visit_type(
    en_title: 'Visit Type Change',
    ar_title: 'تم تعديل نوع الزيارة',
    toNotify: 'Doctor',
  ),
  visit_is_cancled_by_patient(
    en_title: 'Visit Is Canceled By Patient',
    ar_title: 'تم الغاء زيارة بواسطة المريض',
    toNotify: 'Doctor',
  );

  final String en_title;
  final String ar_title;
  final String toNotify;

  const InAppAction({
    required this.en_title,
    required this.ar_title,
    required this.toNotify,
  });
}
