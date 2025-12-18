import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String doc_id;
  final String doctor_subscription_id;
  final double amount;
  final String x_pay_transaction_id;
  final String x_pay_payment_id;
  final String x_pay_transaction_status;

  const Payment({
    required this.id,
    required this.doc_id,
    required this.doctor_subscription_id,
    required this.amount,
    required this.x_pay_transaction_id,
    required this.x_pay_payment_id,
    required this.x_pay_transaction_status,
  });

  Payment copyWith({
    String? id,
    String? doc_id,
    String? doctor_subscription_id,
    double? amount,
    String? x_pay_transaction_id,
    String? x_pay_payment_id,
    String? x_pay_transaction_status,
  }) {
    return Payment(
      id: id ?? this.id,
      doc_id: doc_id ?? this.doc_id,
      doctor_subscription_id:
          doctor_subscription_id ?? this.doctor_subscription_id,
      amount: amount ?? this.amount,
      x_pay_transaction_id: x_pay_transaction_id ?? this.x_pay_transaction_id,
      x_pay_payment_id: x_pay_payment_id ?? this.x_pay_payment_id,
      x_pay_transaction_status:
          x_pay_transaction_status ?? this.x_pay_transaction_status,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'doc_id': doc_id,
      'doctor_subscription_id': doctor_subscription_id,
      'amount': amount,
      'x_pay_transaction_id': x_pay_transaction_id,
      'x_pay_payment_id': x_pay_payment_id,
      'x_pay_transaction_status': x_pay_transaction_status,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as String,
      doc_id: map['doc_id'] as String,
      doctor_subscription_id: map['doctor_subscription_id'] as String,
      amount: map['amount'] as double,
      x_pay_transaction_id: map['x_pay_transaction_id'] as String,
      x_pay_payment_id: map['x_pay_payment_id'] as String,
      x_pay_transaction_status: map['x_pay_transaction_status'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      doc_id,
      doctor_subscription_id,
      amount,
      x_pay_transaction_id,
      x_pay_payment_id,
      x_pay_transaction_status,
    ];
  }

  factory Payment.initial({
    required String doc_id,
    required String doctor_subscription_id,
    required double amount,
  }) {
    return Payment(
      id: '',
      doc_id: doc_id,
      doctor_subscription_id: doctor_subscription_id,
      amount: amount,
      x_pay_transaction_id: '',
      x_pay_payment_id: '',
      x_pay_transaction_status: '',
    );
  }
}
