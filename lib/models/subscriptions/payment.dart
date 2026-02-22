import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String org_id;
  final String plan_id;
  final String payment_date;
  final String paid_via;
  final num paid_amount;
  final String payment_reference;

  const Payment({
    required this.id,
    required this.org_id,
    required this.plan_id,
    required this.payment_date,
    required this.paid_via,
    required this.paid_amount,
    required this.payment_reference,
  });

  Payment copyWith({
    String? id,
    String? org_id,
    String? plan_id,
    String? payment_date,
    String? paid_via,
    num? paid_amount,
    String? payment_reference,
  }) {
    return Payment(
      id: id ?? this.id,
      org_id: org_id ?? this.org_id,
      plan_id: plan_id ?? this.plan_id,
      payment_date: payment_date ?? this.payment_date,
      paid_via: paid_via ?? this.paid_via,
      paid_amount: paid_amount ?? this.paid_amount,
      payment_reference: payment_reference ?? this.payment_reference,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'org_id': org_id,
      'plan_id': plan_id,
      'payment_date': payment_date,
      'paid_via': paid_via,
      'paid_amount': paid_amount,
      'payment_reference': payment_reference,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as String,
      org_id: map['org_id'] as String,
      plan_id: map['plan_id'] as String,
      payment_date: map['payment_date'] as String,
      paid_via: map['paid_via'] as String,
      paid_amount: map['paid_amount'] as num,
      payment_reference: map['payment_reference'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      org_id,
      plan_id,
      payment_date,
      paid_via,
      paid_amount,
      payment_reference,
    ];
  }
}
