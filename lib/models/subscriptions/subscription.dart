import 'package:equatable/equatable.dart';
import 'package:one/models/subscriptions/payment.dart';
import 'package:one/models/subscriptions/plan.dart';
import 'package:pocketbase/pocketbase.dart';

class Subscription extends Equatable {
  final String id;
  final String org_id;
  final String plan_id;
  final num number_of_doctors;
  final String start_date;
  final String end_date;
  final String payment_id;

  const Subscription({
    required this.id,
    required this.org_id,
    required this.plan_id,
    required this.number_of_doctors,
    required this.start_date,
    required this.end_date,
    required this.payment_id,
  });

  Subscription copyWith({
    String? id,
    String? org_id,
    String? plan_id,
    num? number_of_doctors,
    String? start_date,
    String? end_date,
    String? payment_id,
  }) {
    return Subscription(
      id: id ?? this.id,
      org_id: org_id ?? this.org_id,
      plan_id: plan_id ?? this.plan_id,
      number_of_doctors: number_of_doctors ?? this.number_of_doctors,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      payment_id: payment_id ?? this.payment_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'org_id': org_id,
      'plan_id': plan_id,
      'number_of_doctors': number_of_doctors,
      'start_date': start_date,
      'end_date': end_date,
      'payment_id': payment_id,
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as String,
      org_id: map['org_id'] as String,
      plan_id: map['plan_id'] as String,
      number_of_doctors: map['number_of_doctors'] as num,
      start_date: map['start_date'] as String,
      end_date: map['end_date'] as String,
      payment_id: map['payment_id'] as String,
    );
  }

  DateTime get start_date_parsed => DateTime.parse(start_date);

  DateTime get end_date_parsed => DateTime.parse(end_date);

  bool get is_currently_active =>
      start_date_parsed.isBefore(DateTime.now()) &&
      end_date_parsed.isAfter(DateTime.now());

  int get duration_till_expiry =>
      end_date_parsed.difference(DateTime.now()).inDays;

  bool get has_one_month_to_expiry =>
      is_currently_active && duration_till_expiry <= 30;

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      org_id,
      plan_id,
      number_of_doctors,
      start_date,
      end_date,
      payment_id,
    ];
  }
}

class SubscriptionExpanded extends Subscription {
  const SubscriptionExpanded({
    required super.id,
    required super.org_id,
    required super.plan_id,
    required super.number_of_doctors,
    required super.start_date,
    required super.end_date,
    required super.payment_id,
    required this.plan,
    required this.payment,
  });

  final Plan plan;
  final Payment payment;

  factory SubscriptionExpanded.fromRecordModel(RecordModel record) {
    final _plan = Plan.fromJson(
      record.get<RecordModel>('expand.plan_id').toJson(),
    );
    final _payment = Payment.fromJson(
      record.get<RecordModel>('expand.payment_id').toJson(),
    );

    return SubscriptionExpanded(
      id: record.getStringValue('id'),
      org_id: record.getStringValue('org_id'),
      plan_id: record.getStringValue('plan_id'),
      number_of_doctors: record.getIntValue('number_of_doctors'),
      start_date: record.getStringValue('start_date'),
      end_date: record.getStringValue('end_date'),
      payment_id: record.getStringValue('payment_id'),
      plan: _plan,
      payment: _payment,
    );
  }
}
