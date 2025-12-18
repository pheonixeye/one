// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

///[DoctorDrugItem] - [DoctorLabItem] - [DoctorRadItem] - [DoctorProcedureItem] - [DoctorSupplyItem]
abstract class DoctorItem extends Equatable {
  const DoctorItem({
    required this.id,
    required this.item,
    required this.name_en,
    required this.name_ar,
  });

  final ProfileSetupItem item;
  final String id;
  final String name_en;
  final String name_ar;

  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [item, id, name_en, name_ar];
}
