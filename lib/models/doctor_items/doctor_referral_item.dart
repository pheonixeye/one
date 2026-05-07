import 'package:equatable/equatable.dart';
import 'package:one/models/doctor_items/_doctor_item.dart';
import 'package:one/models/doctor_items/profile_setup_item.dart';

class DoctorReferralItem extends DoctorItem implements Equatable {
  const DoctorReferralItem({
    required super.id,
    required super.doc_id,
    required super.name_en,
    required super.name_ar,
    super.item = ProfileSetupItem.referrals,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'doc_id': doc_id,
    };
  }

  factory DoctorReferralItem.fromJson(Map<String, dynamic> map) {
    try {
      return DoctorReferralItem(
        id: map['id'] as String,
        name_en: map['name_en'] as String,
        name_ar: map['name_ar'] as String,
        doc_id: map['doc_id'] as String,
      );
    } catch (e) {
      return DoctorReferralItem.unknown();
    }
  }

  @override
  List<Object> get props => [
    id,
    name_en,
    name_ar,
    doc_id,
  ];

  @override
  bool get stringify => true;

  factory DoctorReferralItem.unknown() {
    return const DoctorReferralItem(
      id: '',
      doc_id: '',
      name_en: 'Unknown',
      name_ar: 'غير معروف',
    );
  }

  factory DoctorReferralItem.onlineBooking([String? doc_id]) {
    return DoctorReferralItem(
      id: '',
      doc_id: doc_id ?? '',
      name_en: 'Online Booking',
      name_ar: 'حجز اونلاين',
    );
  }
}
