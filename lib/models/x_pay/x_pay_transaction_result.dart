import 'package:equatable/equatable.dart';

class XPayTransactionResult extends Equatable {
  final String member_id;
  final String payment_id;
  final double total_amount;
  final String transaction_id;
  final String transaction_status;
  final double total_amount_piasters;

  const XPayTransactionResult({
    required this.member_id,
    required this.payment_id,
    required this.total_amount,
    required this.transaction_id,
    required this.transaction_status,
    required this.total_amount_piasters,
  });

  XPayTransactionResult copyWith({
    String? member_id,
    String? payment_id,
    double? total_amount,
    String? transaction_id,
    String? transaction_status,
    double? total_amount_piasters,
  }) {
    return XPayTransactionResult(
      member_id: member_id ?? this.member_id,
      payment_id: payment_id ?? this.payment_id,
      total_amount: total_amount ?? this.total_amount,
      transaction_id: transaction_id ?? this.transaction_id,
      transaction_status: transaction_status ?? this.transaction_status,
      total_amount_piasters:
          total_amount_piasters ?? this.total_amount_piasters,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'member_id': member_id,
      'payment_id': payment_id,
      'total_amount': total_amount,
      'transaction_id': transaction_id,
      'transaction_status': transaction_status,
      'total_amount_piasters': total_amount_piasters,
    };
  }

  factory XPayTransactionResult.fromJson(Map<String, dynamic> map) {
    return XPayTransactionResult(
      member_id: map['member_id'] as String,
      payment_id: map['payment_id'] as String,
      total_amount: double.parse(map['total_amount'] as String),
      transaction_id: map['transaction_id'] as String,
      transaction_status: map['transaction_status'] as String,
      total_amount_piasters:
          double.parse(map['total_amount_piasters'] as String),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      member_id,
      payment_id,
      total_amount,
      transaction_id,
      transaction_status,
      total_amount_piasters,
    ];
  }
}
