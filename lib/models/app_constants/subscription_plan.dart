import 'package:equatable/equatable.dart';

class SubscriptionPlan extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;
  final int duration_in_days;
  final int price;
  final bool has_offer;
  final int current_discount_percentage;
  final DateTime offer_end_date;

  const SubscriptionPlan({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.duration_in_days,
    required this.price,
    required this.has_offer,
    required this.current_discount_percentage,
    required this.offer_end_date,
  });

  SubscriptionPlan copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    int? duration_in_days,
    int? price,
    bool? has_offer,
    int? current_discount_percentage,
    DateTime? offer_end_date,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      duration_in_days: duration_in_days ?? this.duration_in_days,
      price: price ?? this.price,
      has_offer: has_offer ?? this.has_offer,
      current_discount_percentage:
          current_discount_percentage ?? this.current_discount_percentage,
      offer_end_date: offer_end_date ?? this.offer_end_date,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'duration_in_days': duration_in_days,
      'price': price,
      'has_offer': has_offer,
      'current_discount_percentage': current_discount_percentage,
      'offer_end_date': offer_end_date.toIso8601String(),
    };
  }

  factory SubscriptionPlan.fromJson(Map<String, dynamic> map) {
    return SubscriptionPlan(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      duration_in_days: map['duration_in_days'] as int,
      price: map['price'] as int,
      has_offer: map['has_offer'] as bool,
      current_discount_percentage: map['current_discount_percentage'] as int,
      offer_end_date:
          DateTime.tryParse(map['offer_end_date'] as String) ?? DateTime.now(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name_en,
      name_ar,
      duration_in_days,
      price,
      has_offer,
      current_discount_percentage,
      offer_end_date,
    ];
  }

  int savingPercent(int monthlyCost) {
    final int packageDurationInMonths = (duration_in_days / 30).round();
    final undiscountedCost = monthlyCost * packageDurationInMonths;
    final discountPercent = (price * 100) / undiscountedCost;
    return 100 - discountPercent.round();
  }
}
