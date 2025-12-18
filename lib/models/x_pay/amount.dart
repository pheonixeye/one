import 'package:equatable/equatable.dart';

class XpayAmount extends Equatable {
  final String currency;
  final double amount;
  const XpayAmount({
    this.currency = 'EGP',
    required this.amount,
  });

  XpayAmount copyWith({
    String? currency,
    double? amount,
  }) {
    return XpayAmount(
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'currency': currency,
      'amount': amount,
    };
  }

  factory XpayAmount.fromJson(Map<String, dynamic> map) {
    return XpayAmount(
      currency: map['currency'] as String,
      amount: map['amount'] as double,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [currency, amount];
}
