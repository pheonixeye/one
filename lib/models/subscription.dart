import 'package:equatable/equatable.dart';
import 'package:one/models/payment.dart';

class Subscription extends Equatable {
  //TODO: modify according to new db changes
  final String id;
  final String doc_id;
  final String plan_id;
  final String subscription_status;
  final DateTime start_date;
  final DateTime end_date;
  final String payment_id;
  final Payment? payment;

  const Subscription({
    required this.id,
    required this.doc_id,
    required this.plan_id,
    required this.subscription_status,
    required this.start_date,
    required this.end_date,
    required this.payment_id,
    this.payment,
  });

  Subscription copyWith({
    String? id,
    String? doc_id,
    String? plan_id,
    String? subscription_status,
    DateTime? start_date,
    DateTime? end_date,
    String? payment_id,
    Payment? payment,
  }) {
    return Subscription(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      plan_id: plan_id ?? this.plan_id,
      subscription_status: subscription_status ?? this.subscription_status,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      payment_id: payment_id ?? this.payment_id,
      payment: payment ?? this.payment,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'plan_id': plan_id,
      'subscription_status': subscription_status,
      'start_date': start_date.toIso8601String(),
      'end_date': end_date.toIso8601String(),
      'payment_id': payment_id,
      'payment': payment?.toJson(),
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      plan_id: map['plan_id'] as String,
      subscription_status: map['subscription_status'] as String,
      start_date: DateTime.parse(map['start_date'] as String),
      end_date: DateTime.parse(map['end_date'] as String),
      payment_id: map['payment_id'] as String,
      payment: map['payment'] == null
          ? null
          : Payment.fromJson(map['payment'] as Map<String, dynamic>),
    );
  }
  final _graceDuration = const Duration(days: 7);

  bool get passedExpirationTime {
    return subscription_status == 'active' && DateTime.now().isAfter(end_date);
  }

  bool get inGracePeriod {
    return subscription_status == 'expired' &&
        DateTime.now().isBefore(end_date.add(_graceDuration));
  }

  int get gracePeriodRemaining {
    final _durationAfterEnd = end_date.add(_graceDuration);
    return _durationAfterEnd.difference(DateTime.now()).inDays;
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      doc_id,
      plan_id,
      subscription_status,
      start_date,
      end_date,
      payment_id,
      payment,
    ];
  }
}
